From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: sync filesystem of overlayfs
Date: Mon, 27 Nov 2017 19:51:45 +0200
Message-ID: <CAOQ4uxjnq_zyAOk9pCd3M2uW5mSwkWsgrn8ypgcyJOfygFc4qg@mail.gmail.com>
References: <5862C310-F8B9-40AF-826D-BE867CCDA519@mykernel.net>
 <CAOQ4uxjnVajcd=0tqVYbGiTSmMhN_Pemjn3N2fhTZs4KYasV_w@mail.gmail.com>
 <771732B7-80A0-4011-BC98-9A40375A8858@mykernel.net> <CAOQ4uxiROew32J_Xv7bGnHxaM9iexjJ6dQSbJ1gENbCUtHi1aQ@mail.gmail.com>
 <E07939CC-AD3C-41B9-B500-A15DAEFAE981@mykernel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:40984 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752746AbdK0Rvr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 27 Nov 2017 12:51:47 -0500
Received: by mail-yw0-f181.google.com with SMTP id k3so12173039ywk.8
        for <linux-unionfs@vger.kernel.org>; Mon, 27 Nov 2017 09:51:46 -0800 (PST)
In-Reply-To: <E07939CC-AD3C-41B9-B500-A15DAEFAE981@mykernel.net>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: cgxu <cgxu@mykernel.net>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, suyue@meili-inc.com

On Mon, Nov 27, 2017 at 5:30 PM, cgxu <cgxu@mykernel.net> wrote:
> Hi Amir
>
> Per the previous discussion, my opinion is calling __sync_filesystem() in=
 ovl_sync_fs()
> would be better for current stage. If we pick up overlayfs=E2=80=99s dirt=
y inodes we may need to
> involve writeback and cgroup logics in overlayfs and put all things into =
sync_fs seems
> quite heavy and complex. If you agree I=E2=80=99ll make new patch for rev=
iew.
>

That sounds good to me.

Thanks,
Amir.
