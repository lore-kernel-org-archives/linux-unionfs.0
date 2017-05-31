From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: unionmount-testsuite: backward compat support for REDIRECT_DIR=n
Date: Wed, 31 May 2017 21:53:53 +0300
Message-ID: <CAOQ4uxhxFOOgCTcjwq41ftbCPr=BCxhCTTEWzYydY_DoTjH=WA@mail.gmail.com>
References: <CAOQ4uxiEz0mGEQKmQav+g=kLVfq+Ct9GpZvUq7kGvZG7-7gM0A@mail.gmail.com>
 <20170530203548.GA22558@redhat.com> <CAOQ4uxjN+dTfsc=reXwWhSw8-wOX5nhjFhypaQW0m6kCqKwVCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:33033 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbdEaSxy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 May 2017 14:53:54 -0400
In-Reply-To: <CAOQ4uxjN+dTfsc=reXwWhSw8-wOX5nhjFhypaQW0m6kCqKwVCg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, David Howells <dhowells@redhat.com>

On Wed, May 31, 2017 at 10:56 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, May 30, 2017 at 11:35 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> On Sun, May 28, 2017 at 05:43:45PM +0300, Amir Goldstein wrote:
> ...
>>>
>>> Vivek,
>>>
>>> I added support for running my maser branch with old kernels
>>> or with REDIRECT_DIR=n.
>>>
>>> User needs to request backward compat mode explicitly.
>>> When using new command line arg --xdev,
>>> dir rename tests that would return EXDEV are skipped.
>>>
> ...
>>
>> So --xdev will skip tests which are not supposed to pass without
>> REDIRECT_DIR=n?
>


> Short answer - yes.
>
> Long answer:
> Technically, those tests (rename-empty-dir, rename-pop-dir, rename-move-dir)
> pass on David's master branch by expecting and getting EXDEV.
> My master branch, OTOH, does not verify getting EXDEV with the --xdev
> flag, so it will not uncover a hypothetical regression with REDIRECT_DIR=n
> where those tests no longer return EXDEV.
>

Pushed to master:
680b310 Add a test to verify EXDEV behavior when OVERLAYFS_REDIRECT_DIR=n

>
>>
>> Would be great if we could automate this. That is test which are not valid
>> with current kernel/overlay configuration are skipped automatically. It
>> totally up to you. :-)
>>
>
> Yes, that would be great.
> Need to test "`cat /sys/module/overlay/parameters/redirect_dir`" = Y
> But need to take care to modprobe overlay before the test.
>

Pushed to master:
7a8bd82 Check if redirect_dir is disabled and skip directory rename tests

Cheers,
Amir.
