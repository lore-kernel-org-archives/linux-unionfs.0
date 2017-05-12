From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 4/4] overlay: tag tests 016-018 as experimental
Date: Fri, 12 May 2017 09:16:05 +0300
Message-ID: <CAOQ4uxiNew=sKkz5RFs7b9fgjYM5-Fj4Y09Qg4bsX2TvvMiZwQ@mail.gmail.com>
References: <1494485710-2400-1-git-send-email-amir73il@gmail.com>
 <1494485710-2400-5-git-send-email-amir73il@gmail.com> <20170512040145.GJ7250@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36384 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755816AbdELGQG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 12 May 2017 02:16:06 -0400
In-Reply-To: <20170512040145.GJ7250@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Fri, May 12, 2017 at 7:01 AM, Eryu Guan <eguan@redhat.com> wrote:
> On Thu, May 11, 2017 at 09:55:10AM +0300, Amir Goldstein wrote:
>> The tests 016-018 were added to track overlayfs 'Non-standard behavior'
>> as are documented in Documentation/filesystems/overlayfs.txt, with the
>> intention of fixing those behaviors 'some day'.
>>
>> While that day seems to be seen in the horizon, at least for test 017,
>> it may take a while longer for all those tests to pass.
>> Add those tests to group 'experimental' so at least this special status
>> is published somehow.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>
> The first three patches look good to me, but I'm a bit reluctant on
> merging this one.
>
> To me, this new 'experimental' group serves as an indication of "this
> test is known to fail". But this info already can be found in commit
> logs and comments of these tests. Also fstests had been pushing back
> attempts to add "known issue" support in the past. So I'd rather drop
> this patch.
>
Perfectly fine by me.
I have no problem remembering that those tests fail and why ;)
