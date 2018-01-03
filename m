From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 1/3] common/rc: add scratch shutdown support for overlayfs
Date: Wed, 3 Jan 2018 14:58:58 +0200
Message-ID: <CAOQ4uxg0x3fC_uJMDjD9OB-fZuXJzsib5iAU3qckLqCivSc_KQ@mail.gmail.com>
References: <1513048179-151065-1-git-send-email-cgxu519@icloud.com>
 <20171212091622.GQ2749@eguan.usersys.redhat.com> <CA402BA4-C027-4237-A348-0A7A5E606E56@icloud.com>
 <20171212133911.GU2749@eguan.usersys.redhat.com> <DB72F77F-23E3-4F5E-93CB-F61B94F9EA86@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:42877 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751245AbeACM67 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 Jan 2018 07:58:59 -0500
In-Reply-To: <DB72F77F-23E3-4F5E-93CB-F61B94F9EA86@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Jan 3, 2018 at 2:44 PM, Chengguang Xu <cgxu519@icloud.com> wrote:
>
[...]
> In order to add overlay support in some requirement checks like  _require=
_metadata_journaling,
> I think it=E2=80=99s better save underlying filesystem type to $OVL_BASE_=
FSTYP and doing proper check based
> on it.
>
> Currently $OVL_BASE_FSTYP and $FSTYP all set to =E2=80=9Coverlay=E2=80=9D=
, Is there any specific reason for it?
>

In _overlay_config_override():
        # Config file may specify base fs type, but we obay -overlay flag
        export OVL_BASE_FSTYP=3D"$FSTYP"
        export FSTYP=3Doverlay

So either your setup is wrong or there is a bug.
$OVL_BASE_FSTYP *should* contain the base fs type,
but only if you defined FSTYPE in your config file when running ./check -ov=
erlay

Cheers,
Amir.
