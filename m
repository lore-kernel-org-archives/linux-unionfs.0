From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 2/4] ovl: declare index feature backward compatible
Date: Fri, 10 Nov 2017 16:29:57 +0200
Message-ID: <CAOQ4uxi2p4xqJPS3hJ0j=gjQdv8mufzYR=+MPyN0wPPoAc1Bvg@mail.gmail.com>
References: <1508839381-24750-1-git-send-email-amir73il@gmail.com>
 <1508839381-24750-3-git-send-email-amir73il@gmail.com> <20171110142159.GB16917@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:47263 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751558AbdKJO36 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 Nov 2017 09:29:58 -0500
Received: by mail-yw0-f172.google.com with SMTP id x20so1288929ywg.4
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Nov 2017 06:29:58 -0800 (PST)
In-Reply-To: <20171110142159.GB16917@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Nov 10, 2017 at 4:21 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Oct 24, 2017 at 01:02:59PM +0300, Amir Goldstein wrote:
>> Kconfig description on OVERLAY_FS_INDEX states that "the inodes index
>> feature is read-only backward compatible" and that mounting an overlay
>> with index enabled, disabled and then enabled again "will have
>> unexpected results."
>>
>> Commit d1712d8fef03 ("ovl: fix EIO from lookup of non-indexed upper")
>> makes the results of this enable/disable/enable maneuver just as
>> expected and the results of a plain enable of index feature on existing
>> overlay - some hardlinks may have already been broken and new hardlinks
>> will not be broken on copy up.
>>
>> Now that there is a dedicated config option to opt-in in for backward
>> incompatible index feature, remove the backward compatibility clause from
>> Kconfig description of OVERLAY_FS_INDEX.
>
> What if user does OVERLAY_FS_INDEX_INCOMPAT=n, then this text is still
> relevant?
>

In theory Yes.
Because at the moment, after fixing the EIO behavior,
I am not aware of anything making  OVERLAY_FS_INDEX non backward compat.

You upgrade to index=on
copy up doesn't break hardlinks
downgrade to index=off
copy up breaks hardlinks
upgrade to index=on
copy up joins indexed hardlinks
...
and so on.

Unless there is something else I didn't think of.

The idea with introducing the explicit option OVERLAY_FS_INDEX_INCOMPAT
is that any new index feature (e.g. full index for NFS export) can require
user to commit to not going backwards (i.e. mount -o index=off will fail).

Perhaps we need to work out the details of the allowed transistions
better then I defined them.

Amir.
