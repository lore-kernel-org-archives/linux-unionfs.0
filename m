From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: unionmount-testsuite: backward compat support for REDIRECT_DIR=n
Date: Wed, 31 May 2017 10:56:42 +0300
Message-ID: <CAOQ4uxjN+dTfsc=reXwWhSw8-wOX5nhjFhypaQW0m6kCqKwVCg@mail.gmail.com>
References: <CAOQ4uxiEz0mGEQKmQav+g=kLVfq+Ct9GpZvUq7kGvZG7-7gM0A@mail.gmail.com>
 <20170530203548.GA22558@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:35374 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbdEaH4n (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 May 2017 03:56:43 -0400
In-Reply-To: <20170530203548.GA22558@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, David Howells <dhowells@redhat.com>

On Tue, May 30, 2017 at 11:35 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Sun, May 28, 2017 at 05:43:45PM +0300, Amir Goldstein wrote:
...
>>
>> Vivek,
>>
>> I added support for running my maser branch with old kernels
>> or with REDIRECT_DIR=n.
>>
>> User needs to request backward compat mode explicitly.
>> When using new command line arg --xdev,
>> dir rename tests that would return EXDEV are skipped.
>>
...
>
> So --xdev will skip tests which are not supposed to pass without
> REDIRECT_DIR=n?

Short answer - yes.

Long answer:
Technically, those tests (rename-empty-dir, rename-pop-dir, rename-move-dir)
pass on David's master branch by expecting and getting EXDEV.
My master branch, OTOH, does not verify getting EXDEV with the --xdev
flag, so it will not uncover a hypothetical regression with REDIRECT_DIR=n
where those tests no longer return EXDEV.

The reason I did not revert eae160a ("Relax failure to rename lower directory")
is because I have added more directory rename tests since then, so the revert
itself is not enough and I chose the easier path.

>
> Would be great if we could automate this. That is test which are not valid
> with current kernel/overlay configuration are skipped automatically. It
> totally up to you. :-)
>

Yes, that would be great.
Need to test "`cat /sys/module/overlay/parameters/redirect_dir`" = Y
But need to take care to modprobe overlay before the test.

It's up to me or anyone that wants to send a patch ;-)

Thanks,
Amir.
