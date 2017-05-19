From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 2/2] ovl: constant d_ino across copy up
Date: Fri, 19 May 2017 16:09:50 +0300
Message-ID: <CAOQ4uxghuSQwPfAdgqtsrDApzn75DQWO6dNcNQakb5128CBU-Q@mail.gmail.com>
References: <1494510147-18658-1-git-send-email-amir73il@gmail.com>
 <1494510147-18658-3-git-send-email-amir73il@gmail.com> <CAOQ4uxg3_wLfcCGEn4XjdaCJS8uU3FFYVXRRhzUcSE+rggQ9xA@mail.gmail.com>
 <CAJfpegu6Ah=yKL3V=TVVgS5J=MsusZcMNLAU7gB1aAsesDK6Dw@mail.gmail.com>
 <CAOQ4uxhkd6oSRPfFeMR=ZX-JLMmfq0Xs6C7SrxRTySk=EeMs6g@mail.gmail.com> <CAJfpegu91_C_KgOH+jamYgcwAzrSuknhfHBcA4GoD-6rXR4jpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:36862 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753486AbdESNJv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 19 May 2017 09:09:51 -0400
Received: by mail-oi0-f43.google.com with SMTP id h4so91116574oib.3
        for <linux-unionfs@vger.kernel.org>; Fri, 19 May 2017 06:09:51 -0700 (PDT)
In-Reply-To: <CAJfpegu91_C_KgOH+jamYgcwAzrSuknhfHBcA4GoD-6rXR4jpA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, "open list:OVERLAY FILESYSTEM" <linux-unionfs@vger.kernel.org>

On Fri, May 19, 2017 at 3:22 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, May 19, 2017 at 1:34 PM, Amir Goldstein <amir73il@gmail.com> wrote:

>>>> BTW, couldn't find anything obviously wrong with stat'ing overlay
>>>> dir and dir->d_parent here either, is there?
>>>
>>> One issue is permission checking: lookup needs MAY_EXEC while readdir
>>> needs MAY_READ.  So we can't just call lookup_one_len(), but will have
>>> to do the thing by hand.  Also no need to construct the overlay
>>> dentry, just pre-loading the underlying dentries will have almost all
>>> the pros (and cons).
>>>
>>
>> OK. Let me see if I get this.
>> We will need to do by hand:
>>
>> upperdentry = lookup_one_len(p->name, upperdir, p->len);
>> ovl_check_origin(dir, upperdentry, &originpath);
>>
>> And then call some diminished variant of ovl_getattr() to
>> stat them both and figure out the official ino.
>>
>> Not the end of the world when lower and upper dentries are
>> cached as you noted.
>>
>> BUT, for lookup_one_len(upperdir) we anyway need to
>> ovl_override_creds().
>>
>> Doesn't that pull the rug from under your MAY_EXEC argument?
>> May as well do ovl_override_creds(); lookup_one_len(dir)
>> and be done with it.
>>
>> Unless there are other reasons why this is wrong?
>
> We are supposed use mounter's creds for the underlying fs and task's
> creds for the overlay.  The permission we get with mounter's creds is
> not necessarily a superset of the permissions with the task's creds.
>

Right, so perhaps mounter's creds isn't the right choice.
What we need is to install new credentials with elevated permissions
for lookup. Can we do that?

But looking at this from another perspective, if user can readdir,
but cannot lookup inside it, then user cannot stat the files listed by
readdir and therefore user cannot observe the st_ino/d_ino
inconsistency due to lookup failure. If we say that we don't really
care about this corner case, then we silently ignore -EACCESS
and report the upper d_ino.

But I am mostly debating this for the sake of debating. If you prefer
to do this "by hand" because it's the "right thing to do", that seems
like a good enough reason to me. As I wrote, this reeks of a layer
violation that may come back to bite us in the future,  even if right now,
we cannot figure out why.

Amir.
