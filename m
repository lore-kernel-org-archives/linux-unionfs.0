From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH 02/13] ovl: redirect dir by file handle on copy up
Date: Wed, 19 Apr 2017 18:27:38 +0300
Message-ID: <CAOQ4uxgQ4naPLq2n2GBEyAL0qW=Pwm=Qkw4QX8nwiNmCESDoTA@mail.gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
 <1492387183-18847-3-git-send-email-amir73il@gmail.com> <CAJfpegsiy9_-qmMhFRVq7L23WHq_f0HM4+gQQYeW06-3-guD8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35792 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935131AbdDSP1k (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Apr 2017 11:27:40 -0400
In-Reply-To: <CAJfpegsiy9_-qmMhFRVq7L23WHq_f0HM4+gQQYeW06-3-guD8Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Apr 19, 2017 at 6:16 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, Apr 17, 2017 at 1:59 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> When mounted with mount option redirect_dir=fh,
>> every copy up of lower directory stores the lower
>> dir file handle in overlay.fh xattr of upper dir.
>
> Is there a disadvantage to doing this unconditionally? (Same goes for patch 4)
>
> Is there a disadvantage to doing this even for the non-samefs case?
>

Not that I can think of. It's just that all the features that stable
inode brings
to the table only work for same_fs right now, but we can store overlay.fh
anyway.

When you get a chance please let me know your preference wrt
configuration options.
I don't see a reason to let the user turn off storing overlay.fh?
Is there a reason to let user turn off lookup by fh? for files?
(i.e. to preserve old weird behavior?)

Amir.
