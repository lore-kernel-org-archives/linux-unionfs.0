Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D2F6C77B7D
	for <linux-unionfs@archiver.kernel.org>; Sun, 14 May 2023 19:17:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjENTRU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 14 May 2023 15:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjENTRT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 14 May 2023 15:17:19 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDACFE6F
        for <linux-unionfs@vger.kernel.org>; Sun, 14 May 2023 12:17:17 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id a1e0cc1a2514c-780bb3b964cso2630211241.2
        for <linux-unionfs@vger.kernel.org>; Sun, 14 May 2023 12:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684091837; x=1686683837;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lU/phaQIXgic9vjcdayFr7ONxMLJaGY9ZBR/+rsLn8g=;
        b=lHwC7IZRFmfeVtUtjz2exoNa4USZZu6n4xM0HhZ90yFwOW29Ww98EB4CdOXee6x38b
         U4YNuQ7q3SK+Cwtjb0HGoBxKK98yTf8vfzaNV+WWZITQ8/T1sue6xcakXoeT2wU+/HeG
         yrpsHpNRii0NVp7DgilbCyHq7+ZLTfarN/KJt5CD7jaAUnNAcK9mnK/RVxCzkCmSHOzx
         Id56Ys3tfXsc7VjZfa4V0iMzNC4GcYiyzjOc+F60WIG5Q8jxzt0zlaMbllI86yPhZ5VO
         Q7aEH1y/SPgjyms0yh+usL5rbsH4gfcyogxFJMHbQeTbwBiTOhiHxk024WrZsXNcRxat
         Tp3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684091837; x=1686683837;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lU/phaQIXgic9vjcdayFr7ONxMLJaGY9ZBR/+rsLn8g=;
        b=OXdY5cpwgbsjRvlqLTJMTsmhU+WicP+v9HNjomVDZvq1/G6E3KfkT1OZEXK10DPWj8
         Vd6efQyMOUOd7SurqWGMI37JmACeC+amZoVTI6HNQJICZkhIkD/9CiuTNFXRXl21b6Qi
         oV+n+AIy5kJptForX193Qmfkk4OBAWj2Tu3ahAYfID+4K7VRkQRlMNOYEcc+Z/VnzPrm
         Zs6tFgxx+OL+ftJxj6Qw7ItBwxhjk1Cy74H+W2bmyL63C2y+RlglPdaEEGyekMR+lp4v
         N1wpt+VoiU5vovQWTSJLm+pLq3v8t5wvaSllG01bkCXZPJB1rwZeSI+qJeT3r71/+Yfm
         BQsg==
X-Gm-Message-State: AC+VfDw50BvEi7bPq8VtgISD0E8K+QkNEHJZ6IgUzT6igimTu8zzjhkA
        Ei1OTc6yDHqNQkvo5NbAoSgOtnlH7LCiczQo8pM=
X-Google-Smtp-Source: ACHHUZ7MF6Jx2xkQzZZbjbAkQ/G8cLPpBMFPnmcll38ojoYOmP/IMzSpNpO17Gg6iPFblenaGAArKWYDLUtTC/RRfJI=
X-Received: by 2002:a05:6102:116:b0:436:22fe:1d9 with SMTP id
 z22-20020a056102011600b0043622fe01d9mr7321248vsq.10.1684091836700; Sun, 14
 May 2023 12:17:16 -0700 (PDT)
MIME-Version: 1.0
References: <202305142217.46508384-oliver.sang@intel.com>
In-Reply-To: <202305142217.46508384-oliver.sang@intel.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 14 May 2023 22:17:05 +0300
Message-ID: <CAOQ4uxhM+_FbByg5168ReO48k9HAoaeL7xdLhq-n=rY7_iJAQQ@mail.gmail.com>
Subject: Re: [amir73il:ovl-lazy-lowerdata] [ovl] 1edcaf2012: BUG:KASAN:slab-out-of-bounds_in_ovl_get_lowerstack
To:     kernel test robot <oliver.sang@intel.com>
Cc:     oe-lkp@lists.linux.dev, lkp@intel.com,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, May 14, 2023 at 6:30=E2=80=AFPM kernel test robot <oliver.sang@inte=
l.com> wrote:
>
>
> Hello,
>
> kernel test robot noticed "BUG:KASAN:slab-out-of-bounds_in_ovl_get_lowers=
tack" on:
>
> commit: 1edcaf2012c0645e99125ebae675aa4d73e79880 ("ovl: introduce data-on=
ly lower layers")
> https://github.com/amir73il/linux ovl-lazy-lowerdata
>
> in testcase: xfstests
> version: xfstests-x86_64-06c027a-1_20230501
> with following parameters:
>
>         disk: 4HDD
>         fs: f2fs
>         test: generic-group-63
>
>
>
> compiler: gcc-11
> test machine: 8 threads Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz (Skylake)=
 with 16G memory
>
> (please refer to attached dmesg/kmsg for entire log/backtrace)
>
>
>
> If you fix the issue, kindly add following tag
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Link: https://lore.kernel.org/oe-lkp/202305142217.46508384-oliver.sang@=
intel.com
>
>
> [   65.266308][ T2205] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [   65.274214][ T2205] BUG: KASAN: slab-out-of-bounds in ovl_get_lowersta=
ck+0x68e/0x890 [overlay]
> [   65.282812][ T2205] Read of size 1 at addr ffff8881109471ab by task mo=
unt/2205
> [   65.290003][ T2205]
> [   65.292185][ T2205] CPU: 5 PID: 2205 Comm: mount Tainted: G S         =
        6.3.0-00009-g1edcaf2012c0 #1
> [   65.301789][ T2205] Hardware name: HP HP Z240 SFF Workstation/802E, BI=
OS N51 Ver. 01.63 10/05/2017
> [   65.310704][ T2205] Call Trace:
> [   65.313841][ T2205]  <TASK>
> [   65.316621][ T2205]  dump_stack_lvl+0x37/0x50
> [   65.320959][ T2205]  print_address_description+0x2c/0x3d0
> [   65.327368][ T2205]  print_report+0xb5/0x270
> [   65.331616][ T2205]  ? kasan_addr_to_slab+0xd/0xa0
> [   65.336385][ T2205]  ? ovl_get_lowerstack+0x68e/0x890 [overlay]
> [   65.342281][ T2205]  kasan_report+0xb2/0xe0
> [   65.346447][ T2205]  ? ovl_get_lowerstack+0x68e/0x890 [overlay]
> [   65.352342][ T2205]  ovl_get_lowerstack+0x68e/0x890 [overlay]
> [   65.358068][ T2205]  ovl_fill_super+0xd65/0x1d80 [overlay]
> [   65.363530][ T2205]  ? ovl_make_workdir+0xcb0/0xcb0 [overlay]
> [   65.369255][ T2205]  ? sget+0x3e5/0x4f0
> [   65.373073][ T2205]  ? set_anon_super_fc+0x90/0x90
> [   65.377840][ T2205]  ? ovl_make_workdir+0xcb0/0xcb0 [overlay]
> [   65.383575][ T2205]  mount_nodev+0x45/0xd0
> [   65.387648][ T2205]  ? ovl_own_xattr_set+0x10/0x10 [overlay]
> [   65.393284][ T2205]  legacy_get_tree+0xf1/0x1d0
> [   65.397807][ T2205]  ? security_capable+0x54/0x90
> [   65.402504][ T2205]  vfs_get_tree+0x82/0x300
> [   65.406765][ T2205]  ? ns_capable+0x55/0xe0
> [   65.410946][ T2205]  do_new_mount+0x21e/0x480
> [   65.415304][ T2205]  ? do_add_mount+0x370/0x370
> [   65.419831][ T2205]  ? security_capable+0x54/0x90
> [   65.424534][ T2205]  path_mount+0x2af/0x1520
> [   65.428796][ T2205]  ? kasan_set_track+0x25/0x30
> [   65.433392][ T2205]  ? kasan_save_free_info+0x2e/0x40
> [   65.438421][ T2205]  ? finish_automount+0x5d0/0x5d0
> [   65.443273][ T2205]  ? kmem_cache_free+0x17e/0x430
> [   65.448046][ T2205]  ? getname_flags+0x8e/0x450
> [   65.453158][ T2205]  __x64_sys_mount+0x1fe/0x270
> [   65.457753][ T2205]  ? path_mount+0x1520/0x1520
> [   65.462265][ T2205]  ? from_kgid+0xc0/0xc0
> [   65.466347][ T2205]  ? getname_flags+0x8e/0x450
> [   65.471465][ T2205]  do_syscall_64+0x39/0x80
> [   65.475715][ T2205]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [   65.481430][ T2205] RIP: 0033:0x7f21fd9bf62a
> [   65.485677][ T2205] Code: 48 8b 0d 69 18 0d 00 f7 d8 64 89 01 48 83 c8=
 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00=
 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 36 18 0d 00 f7 d8 64 89 01 48
> [   65.505022][ T2205] RSP: 002b:00007ffd90701fe8 EFLAGS: 00000246 ORIG_R=
AX: 00000000000000a5
> [   65.513237][ T2205] RAX: ffffffffffffffda RBX: 00007f21fdaf3264 RCX: 0=
0007f21fd9bf62a
> [   65.521020][ T2205] RDX: 000055fc22226d40 RSI: 000055fc22226d80 RDI: 0=
00055fc22226d60
> [   65.528811][ T2205] RBP: 000055fc22226960 R08: 000055fc22226c20 R09: 0=
0007f21fda91be0
> [   65.536593][ T2205] R10: 0000000000000000 R11: 0000000000000246 R12: 0=
000000000000000
> [   65.544384][ T2205] R13: 000055fc22226d60 R14: 000055fc22226d40 R15: 0=
00055fc22226960
> [   65.552175][ T2205]  </TASK>
> [   65.555044][ T2205]
> [   65.557228][ T2205] Allocated by task 2205:
> [   65.561397][ T2205]  kasan_save_stack+0x22/0x40
> [   65.565902][ T2205]  kasan_set_track+0x25/0x30
> [   65.570332][ T2205]  __kasan_kmalloc+0x7b/0x90
> [   65.574758][ T2205]  __kmalloc_node_track_caller+0x64/0x140
> [   65.580311][ T2205]  kstrdup+0x37/0x60
> [   65.584051][ T2205]  ovl_fill_super+0x353/0x1d80 [overlay]
> [   65.589522][ T2205]  mount_nodev+0x45/0xd0
> [   65.593603][ T2205]  legacy_get_tree+0xf1/0x1d0
> [   65.598119][ T2205]  vfs_get_tree+0x82/0x300
> [   65.602372][ T2205]  do_new_mount+0x21e/0x480
> [   65.606708][ T2205]  path_mount+0x2af/0x1520
> [   65.610961][ T2205]  __x64_sys_mount+0x1fe/0x270
> [   65.615554][ T2205]  do_syscall_64+0x39/0x80
> [   65.619803][ T2205]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [   65.625522][ T2205]
> [   65.627703][ T2205] The buggy address belongs to the object at ffff888=
110947180
> [   65.627703][ T2205]  which belongs to the cache kmalloc-64 of size 64
> [   65.641354][ T2205] The buggy address is located 0 bytes to the right =
of
> [   65.641354][ T2205]  allocated 43-byte region [ffff888110947180, ffff8=
881109471ab)
> [   65.655535][ T2205]
> [   65.657713][ T2205] The buggy address belongs to the physical page:
> [   65.663953][ T2205] page:000000001bca6559 refcount:1 mapcount:0 mappin=
g:0000000000000000 index:0x0 pfn:0x110947
> [   65.673981][ T2205] ksm flags: 0x17ffffc0000200(slab|node=3D0|zone=3D2=
|lastcpupid=3D0x1fffff)
> [   65.681938][ T2205] raw: 0017ffffc0000200 ffff88810c842640 ffffea00055=
3aec0 0000000000000003
> [   65.690334][ T2205] raw: 0000000000000000 0000000080200020 00000001fff=
fffff 0000000000000000
> [   65.698734][ T2205] page dumped because: kasan: bad access detected
> [   65.704972][ T2205]
> [   65.707157][ T2205] Memory state around the buggy address:
> [   65.712615][ T2205]  ffff888110947080: 00 00 00 00 00 00 00 00 fc fc f=
c fc fc fc fc fc
> [   65.720501][ T2205]  ffff888110947100: 00 00 00 00 00 00 00 00 fc fc f=
c fc fc fc fc fc
> [   65.728380][ T2205] >ffff888110947180: 00 00 00 00 00 03 fc fc fc fc f=
c fc fc fc fc fc
> [   65.736257][ T2205]                                   ^
> [   65.741460][ T2205]  ffff888110947200: fa fb fb fb fb fb fb fb fc fc f=
c fc fc fc fc fc
> [   65.749334][ T2205]  ffff888110947280: 00 00 00 00 00 00 00 00 fc fc f=
c fc fc fc fc fc
> [   65.757202][ T2205] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [   65.765127][ T2205] Disabling lock debugging due to kernel taint
>
>

Thanks for the report.

I pushed a fix to branch ovl-lazy-lowerdata.
I did not add Reported-by because it does not make sense when the
bug in not upstream.
If you test the new branch I can add Tested-by.

Thanks,
Amir.
