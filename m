From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2] ovl: create directories inside merged parent opaque
Date: Wed, 30 Nov 2016 17:57:47 +0200
Message-ID: <CAOQ4uxhxcte6Po5aHXC4YNm4sA_Gyaxbxp2SS3csh=1QGuAbNQ@mail.gmail.com>
References: <CAJfpegs--UYZrZG4KM8uigs5nL-Q_jD3+ssvQMRRSOK4HPWpsw@mail.gmail.com>
 <1479747454-2273-1-git-send-email-amir73il@gmail.com> <CAJfpegtG8z1AN8SXQG3e=dXCMwa58AdL8pyOYnffE-85X04+Dw@mail.gmail.com>
 <CAOQ4uxg=jxigmh--+VprmQGeORftvc6uMhXz1cK7mtE7FrD=7Q@mail.gmail.com>
 <CAJfpegtbrpEQWkH6J6FNsJc70AUNt5KrvkVcK7P4KMqP=LH4Yg@mail.gmail.com>
 <CAOQ4uxjnoShKJ1ZU_iWU8b4bds1FOYmA=0BoDymo37y-84yWcw@mail.gmail.com> <CAJfpegu-Gh3fheRRJ7Otr8CFBzxKPVkQFJMi0KRVeEDUttzwNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:33875 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754446AbcK3P5t (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 30 Nov 2016 10:57:49 -0500
Received: by mail-wj0-f194.google.com with SMTP id xy5so22836651wjc.1
        for <linux-unionfs@vger.kernel.org>; Wed, 30 Nov 2016 07:57:48 -0800 (PST)
In-Reply-To: <CAJfpegu-Gh3fheRRJ7Otr8CFBzxKPVkQFJMi0KRVeEDUttzwNg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Nov 30, 2016 at 5:09 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, Nov 30, 2016 at 3:49 PM, Amir Goldstein <amir73il@gmail.com> wrote:
...
>>
>> So why invent a new private lock when the overlay inode lock is perfectly
>> valid for the job?
>>
>> After we have the inode lock in place, lock_rename() is taken when it is
>> needed for a specific operation (when either upperdir or workdir need to
>> be locked), so releasing it for data copy up is just a free gift.
>>
>> Hope that I managed to clarify rather then confuse more.
>
> It is documented and easy to verify that inode lock is held by the VFS
> for all but one case of copy_up().  However that one exception is not
> documented and pretty hard to verify.  I.e. if there's a call path
> that results in d_real() being called with inode lock, it's going to
> deadlock.  And if that call path is hard to trigger, then testing
> won't reveal this and the bug can remain undetected for a long time.
>

I see. I stand corrected. So I'll let you find the right candidate for
copy up lock.

Amir.
