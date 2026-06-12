import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spiceroute/api/api_client.dart';
import 'package:spiceroute/models/chat.dart';
import 'package:spiceroute/state/chat.dart';

/// Lightweight fake [ApiClient] that returns a stream we drive from
/// the test body so we can interleave `send()`/`cancel()`/`clear()`
/// calls with chunk arrivals in any order.
///
/// Subclassing `ApiClient` directly (instead of hiding it behind an
/// interface) keeps the production code's wiring untouched — there's
/// only one writer of `chatStream` and pulling it out into an abstract
/// surface area would force every callsite to thread a new type for
/// the sake of a single test file.
class _FakeApi extends ApiClient {
  _FakeApi();

  final List<StreamController<String>> _controllers = [];
  final List<CancelToken?> _tokensSeen = [];

  StreamController<String> next() {
    final c = StreamController<String>();
    _controllers.add(c);
    return c;
  }

  @override
  Stream<String> chatStream({
    required List<ChatMessage> messages,
    required String language,
    CancelToken? cancelToken,
  }) {
    _tokensSeen.add(cancelToken);
    if (_controllers.isEmpty) {
      throw StateError('No controller queued. Call next() before send().');
    }
    return _controllers.removeAt(0).stream;
  }
}

void main() {
  test(
    'stop+resend race: old stream cancellation does not clobber new stream',
    () async {
      // Regression: tapping Stop mid-stream and then sending a new
      // message before the old stream observed its cancellation used
      // to land in the old send's catch branch and unconditionally
      // flip `streaming = false` — killing the live spinner while
      // the new reply was still being streamed.
      final api = _FakeApi();
      final ctl = ChatController(api);

      // First send -- stream is open, never closed by the server.
      final streamA = api.next();
      // ignore: unawaited_futures
      final sendA = ctl.send('hello', language: 'en');
      // Yield so send() can enter the await for loop.
      await Future<void>.delayed(Duration.zero);

      // Verify the controller is streaming on the first message.
      expect(ctl.state.streaming, isTrue);
      expect(ctl.state.messages.length, 2); // user + empty model

      // User cancels mid-stream.
      ctl.cancel();
      // Cancel() flips streaming off synchronously.
      expect(ctl.state.streaming, isFalse);

      // User immediately sends a second message, BEFORE the first
      // stream's await-for has observed the cancellation.
      final streamB = api.next();
      // ignore: unawaited_futures
      final sendB = ctl.send('again', language: 'en');
      await Future<void>.delayed(Duration.zero);
      expect(ctl.state.streaming, isTrue);
      expect(ctl.state.messages.length, 4); // 2 old + user + empty

      // NOW the first stream's underlying transport finally raises
      // the cancellation as a DioException. Without the
      // _isStillActive() guard this would set streaming=false even
      // though we're mid-flight on the second send.
      streamA.addError(
        DioException.requestCancelled(
          requestOptions: RequestOptions(path: '/ai/chat/stream'),
          reason: 'user cancel',
        ),
      );
      await streamA.close();
      await Future<void>.delayed(Duration.zero);

      expect(
        ctl.state.streaming,
        isTrue,
        reason:
            'Second send was still streaming when the first send\'s '
            'cancellation finally surfaced — the guard must prevent '
            'the late catch branch from clobbering streaming=true.',
      );

      // Finish the second stream cleanly to release sendB.
      streamB.add('hi there');
      await streamB.close();
      await sendB;
      // sendA's catch branch should have already returned by now.
      await sendA;

      expect(ctl.state.streaming, isFalse);
      expect(ctl.state.messages.last.content, 'hi there');
    },
  );

  test(
    'clear()+send race: late chunk from old stream does not pollute new chat',
    () async {
      // Regression: a slow trailing chunk from a stream the user
      // cleared used to be appended to the LAST message of WHATEVER
      // the messages list looked like at chunk-arrival time. That
      // meant the old reply bleeding into the new conversation's
      // first answer once the user started over.
      final api = _FakeApi();
      final ctl = ChatController(api);

      final streamA = api.next();
      // ignore: unawaited_futures
      ctl.send('first', language: 'en');
      await Future<void>.delayed(Duration.zero);
      streamA.add('partial old reply ');
      await Future<void>.delayed(Duration.zero);
      expect(ctl.state.messages.last.content, 'partial old reply ');

      // User clears, then immediately starts a fresh chat. New
      // CancelToken takes over.
      ctl.clear();
      final streamB = api.next();
      // ignore: unawaited_futures
      ctl.send('totally new question', language: 'en');
      await Future<void>.delayed(Duration.zero);

      // OLD stream now coughs up one more chunk before the cancel
      // propagates. The fence MUST drop it.
      streamA.add(' LEAKED CHUNK');
      await Future<void>.delayed(Duration.zero);
      expect(
        ctl.state.messages.last.content,
        isNot(contains('LEAKED CHUNK')),
        reason:
            'Old stream chunk leaked into the new chat — the in-loop '
            '_isStillActive guard is missing or wrong.',
      );

      streamB.add('fresh answer');
      await streamB.close();
      await Future<void>.delayed(Duration.zero);

      // Cancel out streamA so the old send() can unwind.
      await streamA.close();
      await Future<void>.delayed(Duration.zero);

      expect(ctl.state.messages.last.content, 'fresh answer');
    },
  );
}
