From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 07/23] ovl: verify stored origin fh matches lower dir
Date: Fri, 5 Jan 2018 21:00:45 +0200
Message-ID: <CAOQ4uxh_Z2gS6mOZXdRaHv3558ms9zeFDBK0p4t3NKq4-UwLbA@mail.gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
 <1515084018-25134-8-git-send-email-amir73il@gmail.com> <20180105160427.GD29480@redhat.com>
 <CAOQ4uxg-DfS1iWzozN3LBhDJtO=TLkSjuXY+fe5O3Uz0hCGg-A@mail.gmail.com>
 <20180105163522.GE29480@redhat.com> <CAOQ4uxiEfssudtKVrv-U9eZtyvxx4GRVaDbXiZpaPtH-bGMShw@mail.gmail.com>
 <20180105183334.GG29480@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f180.google.com ([209.85.213.180]:42926 "EHLO
        mail-yb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752219AbeAETAq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 Jan 2018 14:00:46 -0500
Received: by mail-yb0-f180.google.com with SMTP id j197so1266363ybg.9
        for <linux-unionfs@vger.kernel.org>; Fri, 05 Jan 2018 11:00:46 -0800 (PST)
In-Reply-To: <20180105183334.GG29480@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Jan 5, 2018 at 8:33 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Jan 05, 2018 at 06:42:09PM +0200, Amir Goldstein wrote:
[...]
>> >
>> > So for non-dir case, we check origin by default and error out if decoding
>> > of fh fails.  Why not do the same thing for directories as well. I mean
>> > why directory origin check should be hidden behind a mount option
>> > (verfiy=).
>> >
>>
>> Because it is a change of behavior so we need users to opt-in for it.
>> When copying layers, file handles become stale.
>
> But do we support copying layers? Because in that case non-dir
> fh will become stale. So that suggests that we don't support it
> already.

Its perfectly fine if cannot decode origin for non-dir. it is not an error.
just won't use lower inode number.

>
>> As a result, inode numbers of non-dir are taken from upper, but after
>> copying inode numbers change anyway, so the implication is moot.
>
> With metadata copy, implications are very significant again.

Right, but with metadata copy you cannot copy layers.

>
>> You cannot say the same for copied merge dirs with origin that becomes
>> stale. The implication of not following lower dir after copying are significant.
>
> It really feels odd that we will have different behavior for dir and
> non-dir objects when it comes to origin verification. Will a new
> mount option say verify_origin=on/off make sense. That way this is verify
> specific and verifies origin (both for dir and non-dir objects) and user
> will opt in to maintain backward compatibility.
>

I can go with renaming verify to verify_origin.
Let's see what Miklos has to say.

Thanks,
Amir.
