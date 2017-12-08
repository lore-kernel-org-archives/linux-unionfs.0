From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [ANNOUNCE] unionmount-testsuite: Amir's master branch updated
Date: Fri, 8 Dec 2017 18:29:53 +0200
Message-ID: <CAOQ4uxjM6ZLcyU5-nQXz=T98kuhMrCJ+1df85-19QJQjrr7JiA@mail.gmail.com>
References: <CAOQ4uxiiaiq8dettBvZScC59KV-07B-muxE3SS60BDK3dugJow@mail.gmail.com>
 <20171206181700.GA7967@redhat.com> <CAOQ4uxhTWV=ZwDK2DQS2KYux7fufoz0sc7Sv+9dz59gnM1u8+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f178.google.com ([209.85.213.178]:37009 "EHLO
        mail-yb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754545AbdLHQ3z (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 8 Dec 2017 11:29:55 -0500
In-Reply-To: <CAOQ4uxhTWV=ZwDK2DQS2KYux7fufoz0sc7Sv+9dz59gnM1u8+w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, David Howells <dhowells@redhat.com>, fstests <fstests@vger.kernel.org>, Chandan Rajendra <chandan@linux.vnet.ibm.com>

On Wed, Dec 6, 2017 at 9:14 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Dec 6, 2017 at 8:17 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> On Tue, Dec 05, 2017 at 10:20:25PM +0200, Amir Goldstein wrote:
>>> Hi All,
>>>
>>> The master branch on my unionmount-testsuite tree [1] has been updated.
>>>
>>> The head of the master branch is commit:
>>> 6d04664 Add a test for rename over empty union dir
>>>
>>> This small update contains:
>>> - A few new simple dir rename and dir remove tests
>>> - A fix for running on kernel <= v4.9 with no redirect_dir support
>>> - A new setup option --squashfs to setup lower as read-only squashfs
>>>
>>
>> Hi Amir,
>>
>> It would be nice to also update README file and explain different options.
>
> Yes, that would be nice... will get to it some day if someone doesn't
> beat me to it.
>
>>
>> Also, how to test with different mount options enabled/disable (index,
>> redirect etc).
>>
>
> A preview for README:
> Basically, the testsuite tests for correctness, so if correctness requires
> enabling a feature, then testsuite will fail without the feature, but there are
> some historical exceptions:
> - testsuite predates redirect_dir, so I let the testsuite auto detect
> redirect_dir
>   and kept the "expect EXDEV" logic for redirect_dir disabled
> - until quite recently st_ino was not constant on copy up in most cases,
>   so the verification of constant ino was added as an opt-in feature
> with --verify
>
>
>>> With index enabled, there are no known failures.
>>> With index disabled this test fails on non-constant st_ino for lower hardlink
>>> copy up:
>>>   run --ov=1 --samefs --verify rename-mass-5
>
> Thus, this test fails because with index disabled, hardlink is broken on copy up
> and does not preserve st_ino.
>

Vivek,

I added documentation about all the features I added to unionmount-testsuite at:
https://github.com/amir73il/overlayfs/wiki/Overlayfs-testing#Unionmount_testsuite

Will add that link to README on the next master branch update.
Let me know if there is anything missing for you in this wiki page.

Thanks,
Amir.
