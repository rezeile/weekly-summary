import Foundation

func configTest() {
    let config = Config()
    print(config.getDestEmail())
    print(config.getEmailPath())
    print(config.getShellPath())
    print(config.getLaunchArguments())
    print(config.getSourceEmailAddress())
    print(config.getLaunchPath())
}
