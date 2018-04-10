Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:33953 "EHLO
        mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751796AbeDJFiT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 10 Apr 2018 01:38:19 -0400
Received: by mail-yw0-f173.google.com with SMTP id h14so3628078ywm.1
        for <linux-unionfs@vger.kernel.org>; Mon, 09 Apr 2018 22:38:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <779D1CE1-7805-4026-BC7D-3773D5E37B34@gmx.com>
References: <779D1CE1-7805-4026-BC7D-3773D5E37B34@gmx.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 10 Apr 2018 08:38:18 +0300
Message-ID: <CAOQ4uxjuO8ZUH_9Y68-y0JQsF9yunTarF6YFCtSW20V_EjXUFA@mail.gmail.com>
Subject: Re: question of copying stack in ovl_lookup()
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-unionfs-owner@vger.kernel.org
To: "cgxu519@gmx.com" <cgxu519@gmx.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Apr 10, 2018 at 4:29 AM, cgxu519@gmx.com <cgxu519@gmx.com> wrote:
> Hi guys,
>
> I=E2=80=99m a little curious for below code in ovl_lookup, is there any b=
ackground for
> copy stack instead of directly using it?
>
> memcpy(oe->lowerstack, stack, sizeof(struct ovl_path) * ctr);
>

Memory compaction.

stack has ofs->numlower entries, which could be very large,
but after lookup, oe->numlower can end up being much much
smaller. Also, ovl_alloc_entry() packs lowerstack together with
ovl_entry, so the overall memory usage of the long lived overlay
dentry cache entries is lower.

Cheers,
Amir.
