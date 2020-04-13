Return-Path: <SRS0=sf8C=55=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BE08C2BA19
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Apr 2020 10:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0028520678
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Apr 2020 10:15:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="Rhc/Mbqg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgDMKPg (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 13 Apr 2020 06:15:36 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25333 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728253AbgDMKPf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Apr 2020 06:15:35 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1586772920; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=aEsJGRmAaPWqL1vVGYzxX1KQKvgeF983xVoacZ9Kx1XeQO4dNXIg+t6vhC4JRPHyymjABizKfvzogRSZhIzEQsaqCqQi7MJ60CogNLJjXHfwfi5YcWxW1UfQYRSTAC0Av53k7MRF7udw2FepYiPaU7LtH6cSL6Am5UgRr9ARo7c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1586772920; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=logQSLvUXZCKpovGGrsarUVaFoEHbxZyi3Pn/Ejj3qg=; 
        b=aHwGmqEW1/1WPp0VUgF8YCC48EPIaji2ztEHPsKyKERLPjnPrRXWwX0/bKShAp6xyNvg3rQBBHlPfF4TnncOlP8Bpxjxb9NFOzZyP36pObbQ36BSlQvTGd5GnSFHdQ5YUGNsWgx5ul3qar6TZ1B62Sw7O7R3FmkSWPTUYOMpfhE=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1586772920;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=logQSLvUXZCKpovGGrsarUVaFoEHbxZyi3Pn/Ejj3qg=;
        b=Rhc/MbqgZkU6rphDt2Mv2tqb/1iirCZubgmgDeVEpZXsxqKIzoT1u9Eey8zH0sFO
        Uz2fgzIigTBYGE2N7z7bow4JZO2TOro6JZXyWS2b7MxNJk1rB+j+kpy18L2e5TAY4JJ
        cZ49GtZ7AopKVkBvcqJ16qNqemDRC/6DurKn0+Y0=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1586772917751384.2737611692895; Mon, 13 Apr 2020 18:15:17 +0800 (CST)
Date:   Mon, 13 Apr 2020 18:15:17 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Amir Goldstein" <amir73il@gmail.com>
Cc:     "Eryu Guan" <guaneryu@gmail.com>,
        "fstests" <fstests@vger.kernel.org>,
        "overlayfs" <linux-unionfs@vger.kernel.org>,
        "Miklos Szeredi" <miklos@szeredi.hu>
Message-ID: <17173093df3.f6003c6d6224.1796766948671904062@mykernel.net>
In-Reply-To: <CAOQ4uxghdvj9QVJ3DQ3g1p0hbvz5mfMoxgoEAKyQAf4v78p2YA@mail.gmail.com>
References: <20200410012059.27210-1-cgxu519@mykernel.net> <20200410012059.27210-2-cgxu519@mykernel.net> <CAOQ4uxghdvj9QVJ3DQ3g1p0hbvz5mfMoxgoEAKyQAf4v78p2YA@mail.gmail.com>
Subject: Re: [PATCH 2/2] overlay/072: test for sharing inode with whiteout
 files
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=94, 2020-04-10 15:21:51 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Fri, Apr 10, 2020 at 4:21 AM Chengguang Xu <cgxu519@mykernel.net> wro=
te:
 > >
 > > This is a test for whiteout inode sharing feature.
 > >
 > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > > ---
 > > Hi Eryu,
 > >
 > > Kernel patch of this feature is still in review but I hope to merge
 > > test case first, so that we can check the correctness in a convenient
 > > way. The test case will carefully check new module param and skip the
 > > test if the param does not exist.
 > >
 > >
 > >  tests/overlay/072     | 148 +++++++++++++++++++++++++++++++++++++++++=
+
 > >  tests/overlay/072.out |   2 +
 > >  tests/overlay/group   |   1 +
 > >  3 files changed, 151 insertions(+)
 > >  create mode 100755 tests/overlay/072
 > >  create mode 100644 tests/overlay/072.out
 > >
 > > diff --git a/tests/overlay/072 b/tests/overlay/072
 > > new file mode 100755
 > > index 00000000..1cff386d
 > > --- /dev/null
 > > +++ b/tests/overlay/072
 > > @@ -0,0 +1,148 @@
 > > +#! /bin/bash
 > > +# SPDX-License-Identifier: GPL-2.0
 > > +# Copyright (c) 2020 Chengguang Xu <cgxu519@mykernel.net>.
 > > +# All Rights Reserved.
 > > +#
 > > +# FS QA Test 072
 > > +#
 > > +# This is a test for inode sharing with whiteout files.
 > > +#
 > > +seq=3D`basename $0`
 > > +seqres=3D$RESULT_DIR/$seq
 > > +echo "QA output created by $seq"
 > > +
 > > +here=3D`pwd`
 > > +tmp=3D/tmp/$
 > > +status=3D1       # failure is the default!
 > > +trap "_cleanup; exit \$status" 0 1 2 3 15
 > > +
 > > +_cleanup()
 > > +{
 > > +       cd /
 > > +       rm -f $tmp.*
 > > +}
 > > +
 > > +# get standard environment, filters and checks
 > > +. ./common/rc
 > > +. ./common/filter
 > > +
 > > +# remove previous $seqres.full before test
 > > +rm -f $seqres.full
 > > +
 > > +# real QA test starts here
 > > +_supported_fs overlay
 > > +_supported_os Linux
 > > +_require_test
 > > +_require_scratch
 > > +
 > > +param_name=3D"whiteout_link_max"
 > > +check_whiteout_link_max()
 > > +{
 > > +       local param_value=3D`_get_fs_module_param ${param_name}`
 >=20
 > Keep this value and set it back on _cleanup()
 >=20
 > > +       if [ -z ${param_value} ]; then
 > > +               _notrun "${FSTYP} module param ${param_name} does not =
exist"
 >=20
 > This message will be more helpful:
 > "overlayfs does not support whiteout inode sharing"
 >=20
 > > +       fi
 > > +}
 > > +
 > > +lowerdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 > > +upperdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
 > > +merged=3D$OVL_BASE_SCRATCH_MNT/$OVL_MNT
 >=20
 > Best if you use $SCRATCH_MNT instead of $merged
 >=20
 > > +
 > > +#Make some files in lowerdir.
 > > +make_lower_files()
 > > +{
 > > +       seq 1 $file_count | while read line; do
 >=20
 > I think that a for statement would be more readable here.
 >=20
 > > +               `touch $lowerdir/test${line} 1>&2 2>/dev/null`
 > > +       done
 > > +}
 > > +
 > > +#Delete all copy-uped files in upperdir.
 > > +make_whiteout_files()
 > > +{
 > > +       rm -f $merged/* 1>&2 2>/dev/null
 > > +}
 > > +
 > > +#Check link count of whiteout files.
 > > +check_whiteout_files()
 > > +{
 > > +       seq 1 $file_count | while read line; do
 > > +               local real_count=3D`stat -c %h $upperdir/test${line} 2=
>/dev/null`
 > > +               if [[ $link_count !=3D $real_count ]]; then
 > > +                       echo "Expected whiteout link count is $link_co=
unt but real count is $real_count"
 > > +               fi
 > > +       done
 > > +}
 > > +
 > > +check_whiteout_link_max
 > > +
 > > +# Case1:
 > > +# Setting whiteout_link_max=3D0 will not share inode
 > > +# with whiteout files, it means each whiteout file
 > > +# will has it's own inode.
 > > +
 > > +file_count=3D10
 > > +link_max=3D0
 > > +link_count=3D1
 >=20
 > Would be nicer to put all the below in a run_test_case() function
 > with above as arguments.
 >=20

Something like below?
---------
# Arguments:
# $1: Maximum link count
# $2: Testing file number
# $3: Expected link count
run_test_case()
{
        _scratch_mkfs
        _set_fs_module_param $param_name ${1}
        make_lower_files ${2}
        _scratch_mount
        make_whiteout_files
        check_whiteout_files ${2} ${3}
        $UMOUNT_PROG $SCRATCH_MNT
}

link_max=3D1
file_count=3D10
link_count=3D1
run_test_case $link_max $file_count $link_count
---------

 > > +_scratch_mkfs
 > > +_set_fs_module_param $param_name $link_max
 > > +make_lower_files
 > > +_scratch_mount
 > > +make_whiteout_files
 > > +check_whiteout_files
 > > +$UMOUNT_PROG $OVL_BASE_SCRATCH_MNT/$OVL_MNT
 >=20
 > Better:
 > $UMOUNT_PROG $SCRATCH_MNT
 >=20
 > Even better:
 > _scratch_umount

I haven't found the definition of _scratch_umount,
have we implemented it?


 >=20
 > The difference is that if the test case has reference leaks on inode or
 > dentry, _overlay_base_unmount() will detect them.
 >=20
 > > +
 > > +# Case2:
 > > +# Setting whiteout_link_max=3D1 will not share inode
 > > +# with whiteout files, it means each whiteout file
 > > +# will has it's own inode.
 > > +
 > > +file_count=3D10
 > > +link_max=3D1
 > > +link_count=3D1
 > > +_scratch_mkfs
 > > +_set_fs_module_param $param_name $link_max
 > > +make_lower_files
 > > +_scratch_mount
 > > +make_whiteout_files
 > > +check_whiteout_files $link_count
 > > +$UMOUNT_PROG $OVL_BASE_SCRATCH_MNT/$OVL_MNT
 > > +
 > > +# Case3:
 > > +# Setting whiteout_link_max=3D2 will not share inode
 > > +# with whiteout files, it means each whiteout file
 > > +# will has it's own inode. However, the inode will
 > > +# be shared with tmpfile(in workdir) which is used
 > > +# for creating whiteout file.
 >=20
 > First, that is  strange outcome of whiteout_link_max=3D2
 > I would not expect it.
 > Second, how can every whiteout be shared with tmpfile?
 > There should be at most one tmpfile at all times, so the
 > whiteouts that already reached whiteout_link_max should
 > not be linked to any tmpfile.

I think I misunderstood your comment in my kernel patch, so I changed
the logic to keep all tmpfiles in workdir and cleanup them during next moun=
t.
I'll fix it in V3 kernel patch.

 >=20
 > Please add to test_case() verification that work dir contains
 > at most one tmpfile.
 > But please make sure that the test is clever enough to check
 > both work and index dirs for tmpfiles (names beginning with #).
 >=20

So should I check module params of index and nfs_export for checking
tmpfile in index dir?

Thanks,
cgxu

