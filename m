From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v3 1/3] common/rc: add scratch shutdown support for
 overlayfs
Date: Wed, 03 Jan 2018 22:25:54 +0800
Message-ID: <698CC47A-DC4A-4705-B112-6AAC36A088A4@icloud.com>
References: <1513048179-151065-1-git-send-email-cgxu519@icloud.com>
 <20171212091622.GQ2749@eguan.usersys.redhat.com>
 <CA402BA4-C027-4237-A348-0A7A5E606E56@icloud.com>
 <20171212133911.GU2749@eguan.usersys.redhat.com>
 <DB72F77F-23E3-4F5E-93CB-F61B94F9EA86@icloud.com>
 <CAOQ4uxg0x3fC_uJMDjD9OB-fZuXJzsib5iAU3qckLqCivSc_KQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp002.me.com ([17.142.213.63]:46197 "EHLO
        pv33p36im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752750AbeACO0U (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 Jan 2018 09:26:20 -0500
In-reply-to: <CAOQ4uxg0x3fC_uJMDjD9OB-fZuXJzsib5iAU3qckLqCivSc_KQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

>=20
> =D4=DA 2018=C4=EA1=D4=C23=C8=D5=A3=AC=CF=C2=CE=E78:58=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Wed, Jan 3, 2018 at 2:44 PM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>>=20
> [...]
>> In order to add overlay support in some requirement checks like  =
_require_metadata_journaling,
>> I think it=A1=AFs better save underlying filesystem type to =
$OVL_BASE_FSTYP and doing proper check based
>> on it.
>>=20
>> Currently $OVL_BASE_FSTYP and $FSTYP all set to =A1=B0overlay=A1=B1, =
Is there any specific reason for it?
>>=20
>=20
> In _overlay_config_override():
>        # Config file may specify base fs type, but we obay -overlay =
flag
>        export OVL_BASE_FSTYP=3D"$FSTYP"
>        export FSTYP=3Doverlay
>=20
> So either your setup is wrong or there is a bug.
> $OVL_BASE_FSTYP *should* contain the base fs type,
> but only if you defined FSTYPE in your config file when running =
./check -overlay

Yeah, I didn=A1=AFt specify by hand in config file and just supposed to =
detect automatically.
I didn=A1=AFt check very carefully but seems just slight modification =
like below could let it=20
support auto detection.


$ git diff
diff --git a/check b/check
index f8db3cd..e460424 100755
--- a/check
+++ b/check
@@ -265,7 +265,7 @@ while [ $# -gt 0 ]; do
        -nfs)           FSTYP=3Dnfs ;;
        -glusterfs)     FSTYP=3Dglusterfs ;;
        -cifs)          FSTYP=3Dcifs ;;
-       -overlay)       FSTYP=3Doverlay; export OVERLAY=3Dtrue ;;
+       -overlay)       export OVERLAY=3Dtrue ;;
        -pvfs2)         FSTYP=3Dpvfs2 ;;
        -tmpfs)         FSTYP=3Dtmpfs ;;
        -ubifs)         FSTYP=3Dubifs ;;
diff --git a/common/config b/common/config
index d0fbfe5..e21d8ee 100644
--- a/common/config
+++ b/common/config
@@ -530,7 +530,9 @@ _overlay_config_override()
        [ -b "$TEST_DEV" ] || return 0

        # Config file may specify base fs type, but we obay -overlay =
flag
-       export OVL_BASE_FSTYP=3D"$FSTYP"
+       if [ -z $OVL_BASE_FSTYP ]; then
+               export OVL_BASE_FSTYP=3D"$FSTYP"
+       fi
        export FSTYP=3Doverlay

        # Store original base fs vars
@@ -691,13 +693,6 @@ get_next_config() {
                _check_device SCRATCH_LOGDEV optional $SCRATCH_LOGDEV
        fi

-       # Override FSTYP from config when running ./check -overlay
-       # and maybe override base fs TEST/SCRATCH_DEV with overlay base =
dirs.
-       # We need to do this *after* default mount options are set by =
base FSTYP
-       # and *after* SCRATCH_DEV is deduced from SCRATCH_DEV_POOL
-       if [ "$OVERLAY" =3D=3D "true" -o "$FSTYP" =3D=3D "overlay" ]; =
then
-               _overlay_config_override
-       fi
 }

 if [ -z "$CONFIG_INCLUDED" ]; then
@@ -711,6 +706,15 @@ if [ -z "$CONFIG_INCLUDED" ]; then
           [ ! -z "$TEST_DEV" ]; then
                FSTYP=3D`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
        fi
+
+       # Override FSTYP from config when running ./check -overlay
+       # and maybe override base fs TEST/SCRATCH_DEV with overlay base =
dirs.
+       # We need to do this *after* default mount options are set by =
base FSTYP
+       # and *after* SCRATCH_DEV is deduced from SCRATCH_DEV_POOL
+       if [ "$OVERLAY" =3D=3D "true" -o "$FSTYP" =3D=3D "overlay" ]; =
then
+               _overlay_config_override
+       fi
+
        FSTYP=3D${FSTYP:=3Dxfs}
        export FSTYP
        [ -z "$MOUNT_OPTIONS" ] && _mount_opts



Thanks,
Chengguang.
