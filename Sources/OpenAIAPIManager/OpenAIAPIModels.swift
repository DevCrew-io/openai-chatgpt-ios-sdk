//
//  ChatGPTAPIModels.swift
//  
//
//  Created by Najam us Saqib on 7/5/23.
//

import Foundation

// MARK: - ChatGPTModels Enum
/// Enum representing different ChatGPT models.
public enum OpenAIAPIModels: String {
    case gptThreePointFiveTurbo = "gpt-3.5-turbo"
    case engine =  "davinci"
    
    // Completions
    /// Can do any language task with better quality, longer output, and consistent instruction-following than the curie, babbage, or ada models. Also supports inserting completions within text.
    case  textDavinci003 = "text-davinci-003"
    /// Similar capabilities to text-davinci-003 but trained with supervised fine-tuning instead of reinforcement learning.
    case  textDavinci002 = "text-davinci-002"
    case  textDavinci001 = "text-davinci-001"
    /// Very capable, faster and lower cost than Davinci.
    case  textCurie = "text-curie-001"
    /// Capable of straightforward tasks, very fast, and lower cost.
    case  textBabbage = "text-babbage-001"
    /// Capable of very simple tasks, usually the fastest model in the GPT-3 series, and lowest cost.
    case  textAda = "text-ada-001"
   
    
}

// MARK: - AudioGPTModels Enum -
public enum AudioGPTModels: String {
    case whisper1 = "whisper-1"
}

// MARK: - TextEditModel Enum -
public enum EditGPTModels: String {
    case textDavinciEdit001 = "text-davinci-edit-001"
    case codeDavinciEdit001 = "code-davinci-edit-001"
}

// MARK: - AudioGPTModels Enum -
public enum ModerationGPTModels: String {
    case textModerationStable = "text-moderation-stable"
    case textModerationLatest = "text-moderation-latest"
}

// MARK: - EmbeddingGPTModels Enum -
public enum EmbeddingGPTModels: String {
    case textEmbeddingAda002 = "text-embedding-ada-002"
}

