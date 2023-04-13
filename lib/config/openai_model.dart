enum OpenAIModel {
  gpt4, //어떤 GPT-3.5 모델보다 더 많은 기능을 제공하고 더 복잡한 작업을 수행할 수 있으며 채팅에 최적화되어 있습니다. 최신 모델 반복으로 업데이트됩니다.
  gpt4_0314, //2023년 3월 14일 스냅샷 gpt-4. 달리 gpt-4이 모델은 업데이트를 받지 않으며 2023년 6월 14일에 종료되는 3개월 동안만 지원됩니다.
  gpt4_32k, //기본 gpt-4모드와 동일한 기능이지만 컨텍스트 길이는 4배입니다. 최신 모델 반복으로 업데이트됩니다.
  gpt4_32k_0314, //2023년 3월 14일 스냅샷 gpt-4-32. 달리 gpt-4-32k이 모델은 업데이트를 받지 않으며 2023년 6월 14일에 종료되는 3개월 동안만 지원됩니다.
  gpt3_5_turbo, //가장 유능한 GPT-3.5 모델이며 1/10 비용으로 채팅에 최적화되었습니다 text-davinci-003. 최신 모델 반복으로 업데이트됩니다.
  gpt3_5_turbo_0301 //2023년 3월 1일 스냅샷 gpt-3.5-turbo. 달리 gpt-3.5-turbo이 모델은 업데이트를 받지 않으며 2023년 6월 1일에 끝나는 3개월 동안만 지원됩니다.
}

String getOepnAIModel(OpenAIModel model) {
  switch (model) {
    case OpenAIModel.gpt4:
      return 'gpt-4';
    case OpenAIModel.gpt4_0314:
      return 'gpt-4-0314';
    case OpenAIModel.gpt4_32k:
      return 'gpt-4-32k';
    case OpenAIModel.gpt4_32k_0314:
      return 'gpt-4-32k-0314';
    case OpenAIModel.gpt3_5_turbo:
      return 'gpt-3.5-turbo';
    case OpenAIModel.gpt3_5_turbo_0301:
      return 'gpt-3.5-turbo-0301';
  }
}
