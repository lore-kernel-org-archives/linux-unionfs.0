From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: information of statfs
Date: Wed, 10 Jan 2018 10:08:05 +0200
Message-ID: <CAOQ4uxg3KmGvijf7pOZfCQCWpgJX4MXYbPWVDk1=tZz-fiyNiQ@mail.gmail.com>
References: <6ABBC786-3164-4A8A-A7B8-6BE7F91E8DFD@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:35281 "EHLO
        mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755147AbeAJIIH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 10 Jan 2018 03:08:07 -0500
Received: by mail-yw0-f176.google.com with SMTP id u21so3560935ywc.2
        for <linux-unionfs@vger.kernel.org>; Wed, 10 Jan 2018 00:08:06 -0800 (PST)
In-Reply-To: <6ABBC786-3164-4A8A-A7B8-6BE7F91E8DFD@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Jan 10, 2018 at 8:17 AM, Chengguang Xu <cgxu519@icloud.com> wrote:
> Hello,
>
> This is just my suggestion, in ovl_statfs() isn=E2=80=99t it better to se=
t
> below fields(indicating available free resource) to zero when overlayfs
> doesn=E2=80=99t have upper fs=EF=BC=9FBecause overlayfs can not occupy re=
source in
> lower stack fs anymore, I think it can reduce the possibility of
> misunderstanding from caller.
>

I see the logic in your proposal, but I don't think that behavior is consis=
tent
w.r.t other fs that are mounted readonly.
In what way is an overlay mount with no upper different than any fs that
is mounted readonly?
statfs from a readonly fs returns non-zero free blocks even though write is
not possible.
The user gets a different error when trying to write (EROFS) and not
ENOSPC, so where do you see a chance of misunderstanding from caller?

Thanks,
Amir.
