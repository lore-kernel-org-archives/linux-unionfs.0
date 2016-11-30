From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2] ovl: create directories inside merged parent opaque
Date: Wed, 30 Nov 2016 16:09:25 +0100
Message-ID: <CAJfpegu-Gh3fheRRJ7Otr8CFBzxKPVkQFJMi0KRVeEDUttzwNg@mail.gmail.com>
References: <CAJfpegs--UYZrZG4KM8uigs5nL-Q_jD3+ssvQMRRSOK4HPWpsw@mail.gmail.com>
 <1479747454-2273-1-git-send-email-amir73il@gmail.com> <CAJfpegtG8z1AN8SXQG3e=dXCMwa58AdL8pyOYnffE-85X04+Dw@mail.gmail.com>
 <CAOQ4uxg=jxigmh--+VprmQGeORftvc6uMhXz1cK7mtE7FrD=7Q@mail.gmail.com>
 <CAJfpegtbrpEQWkH6J6FNsJc70AUNt5KrvkVcK7P4KMqP=LH4Yg@mail.gmail.com> <CAOQ4uxjnoShKJ1ZU_iWU8b4bds1FOYmA=0BoDymo37y-84yWcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34606 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933615AbcK3PJk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 30 Nov 2016 10:09:40 -0500
Received: by mail-oi0-f68.google.com with SMTP id m75so23379096oig.1
        for <linux-unionfs@vger.kernel.org>; Wed, 30 Nov 2016 07:09:26 -0800 (PST)
In-Reply-To: <CAOQ4uxjnoShKJ1ZU_iWU8b4bds1FOYmA=0BoDymo37y-84yWcw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Nov 30, 2016 at 3:49 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Nov 30, 2016 at 4:19 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Wed, Nov 30, 2016 at 1:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>
>>> In case you are still interested, I rebase concurrent copy up
>>> on top of overlay-rorw and pushed to branch #concurrent_copyup
>>> on my github, with slightly improved commit message.
>>> But I guess this merge window is crowded enough already and
>>> I personally much rather see rorw merged than concurrent copy up.
>>
>> My problem with the concurrent copy up is the complexity of locking
>> rules.  Why not do some sort of overlay private lock here?
>>
>> If a mutex is deemed too expensive, then just a bool "copying" in
>> ovl_entry and a waitq in ovl_fs in would do.
>>
>
> I am quite certain that I was not able to explain my change properly
> and that if you understood it you wouldn't call it complex.
> If anything, it simplifies the locking rules.
>
> Before my change, there is no clear definition of which locks are held
> when calling ovl_copy_up(), but for all call sites besides
> ovl_open_maybe_copy_up(), the overlay inode is already locked (by vfs).
>
> My change only aligns the ovl_open_maybe_copy_up() case with the
> rest of the code paths by taking the inode lock before calling ovl_copy_up()
> and then the locking requirements for entry to ovl_copy_up() are
> uniform across the code (and documented).
>
> So why invent a new private lock when the overlay inode lock is perfectly
> valid for the job?
>
> After we have the inode lock in place, lock_rename() is taken when it is
> needed for a specific operation (when either upperdir or workdir need to
> be locked), so releasing it for data copy up is just a free gift.
>
> Hope that I managed to clarify rather then confuse more.

It is documented and easy to verify that inode lock is held by the VFS
for all but one case of copy_up().  However that one exception is not
documented and pretty hard to verify.  I.e. if there's a call path
that results in d_real() being called with inode lock, it's going to
deadlock.  And if that call path is hard to trigger, then testing
won't reveal this and the bug can remain undetected for a long time.

The current situation OTOH is perfectly fine, because copy up does not
rely on overlay inode being locked, so it simply does not matter if
the caller holds it or not.

Thanks,
Miklos
