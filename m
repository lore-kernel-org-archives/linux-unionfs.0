From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3] overlay: test unstable inode number
Date: Mon, 12 Dec 2016 11:21:48 +0200
Message-ID: <CAOQ4uxhFDLr3XU7J-MGM2_L=UCHi8B99=p2C_kAj6mYUpsxstw@mail.gmail.com>
References: <1481532306-26938-1-git-send-email-amir73il@gmail.com> <20161212090851.GW29149@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:35724 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932196AbcLLJVu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 12 Dec 2016 04:21:50 -0500
In-Reply-To: <20161212090851.GW29149@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Mon, Dec 12, 2016 at 11:08 AM, Eryu Guan <eguan@redhat.com> wrote:
> On Mon, Dec 12, 2016 at 10:45:06AM +0200, Amir Goldstein wrote:
>> Introduce a new test to demonstrate a known issue with overlayfs:
>> - stat file A shows inode number X
>> - modify A to trigger copy up
>> - stat file A shows inode number Y != X
>>
>> Also test if d_ino of readdir entries changes after copy up.
>>
>> There is a POC patch by Miklos Szeredi that fixes this issue.
>>
>> Not dealing with hardlinks here, because there is more to test
>> then stable inode number.
>> Hardlinks will get a test of their own.
>
> Thanks! I added the missing SOB line, and added "copyup" group too.
>

Right. Thanks.
I audited existing tests and I believe my 016 also calls for "copyup" tag
and 013 as well.
Do you want a patch for that or will you fix it up yourself?

Amir.
