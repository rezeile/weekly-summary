import Foundation

func configTest() {
    let config = Config()
    print(config.getDestEmail())
    print(config.getEmailPath())
    print(config.getLaunchArguments())
    print(config.getLaunchPath())
    print(config.getShellPath())
    print(config.getSourceEmailAddress())
}


