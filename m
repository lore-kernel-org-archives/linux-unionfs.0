Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1AA5CE7A88
	for <linux-unionfs@archiver.kernel.org>; Sun, 24 Sep 2023 15:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjIXPJB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 24 Sep 2023 11:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjIXPJB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 24 Sep 2023 11:09:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92715CF
        for <linux-unionfs@vger.kernel.org>; Sun, 24 Sep 2023 08:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695568133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=fIG2sm5RNfWHTPSMmtFqXVIwcOsmXElzwXi6PPiK5Hc=;
        b=QTeUqfjjT1/kyW9q6RxUV6c1hEhTuMT3wRsU5P+R8+iAzXj7LnKAnKMoehfMqCzeVL7uWo
        kgxT8Ezb7jAtNSdogybyQuEvMgkBlokcQl5yK1uFazbd4ONc9EkfJIYpNov5LlEXRBZm9G
        ImXwII3QGBVuVYpSpzTWhiltG3KYPr0=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-xY9TK8j3MX66CVE8NfyV_A-1; Sun, 24 Sep 2023 11:08:52 -0400
X-MC-Unique: xY9TK8j3MX66CVE8NfyV_A-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-411f95b1a31so59140211cf.1
        for <linux-unionfs@vger.kernel.org>; Sun, 24 Sep 2023 08:08:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695568131; x=1696172931;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fIG2sm5RNfWHTPSMmtFqXVIwcOsmXElzwXi6PPiK5Hc=;
        b=SU68G+ESGjQ+vNAQG1V0Osi/H9EyEUegeAdUljHTv5i9eZOJuQJ8XqDRZgjY49d0//
         f6kBgbOrogzu84p/szxwG352nY2ZrtY0NPbvCrVFyzN40OnjB2quTOpKIo4Ar+bRP0tZ
         3E0qWK/CsnNSnXTQBwqhdAk9E+Zi9j5iPElqvI5Tz0eYCDDKGGt7+hD8Bt6tCKd0K2ya
         +YU49VPKfkI933QtVJOptVFuU/XuRnCEpXQnd7rgoihr8ZZ228cI1P/y9i7xgR5mkFoB
         UcMg23QYIEGOB4oG7BpRoZs9XGGBADRNU5ymmNzTOAx+J9QHKq9smP15Ih/kyDpRBzJa
         famQ==
X-Gm-Message-State: AOJu0YyaUZjYtwLGMiU03yLTSGqDukaxUlkTLSOUAizpT5D4dX5QDGRY
        MteiN3BRf2hK93k9bTQKuhK72e/zAlxBf3pAqDGIdcU8OetMDrl/IEDoTlq65gM5fsK7tWDaGWl
        EsS/SnxZxfXqURFAEBd4KrA+XmEfc51NheHEfcZVA8VubhiP70Q3xxXVhRDoEPKXi/6E+f+A+zO
        mp5azGlJH7
X-Received: by 2002:a17:90a:348:b0:277:33b1:94dd with SMTP id 8-20020a17090a034800b0027733b194ddmr2559659pjf.38.1695565799559;
        Sun, 24 Sep 2023 07:29:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECBJ3uWaRqnSrc5iecOg/F9W1tgP6Xzxs5iet/P+ekM7fNFWGP1H3RzS5S5DfY9cTey6ILQA==
X-Received: by 2002:a17:90a:348:b0:277:33b1:94dd with SMTP id 8-20020a17090a034800b0027733b194ddmr2559639pjf.38.1695565799044;
        Sun, 24 Sep 2023 07:29:59 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c15-20020a17090abf0f00b0027463d5b862sm7986296pjs.49.2023.09.24.07.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Sep 2023 07:29:58 -0700 (PDT)
From:   Zorro Lang <zlang@redhat.com>
X-Google-Original-From: Zorro Lang <zlang@kernel.org>
Date:   Sun, 24 Sep 2023 22:29:55 +0800
To:     linux-unionfs@vger.kernel.org
Cc:     io-uring@vger.kernel.org, fstests@vger.kernel.org
Subject: [xfstests generic/617] fsx io_uring dio starts to fail on overlayfs
 since v6.6-rc1
Message-ID: <20230924142754.ejwsjen5pvyc32l4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi,

The generic/617 of fstests is a test case does IO_URING soak direct-IO
fsx test, but recently (about from v6.6-rc1 to now) it always fails on
overlayfs as [1], no matter the underlying fs is ext4 or xfs. But it
never failed on overlay before, likes [2].

So I thought it might be a regression of overlay or io-uring on current v6.6.
Please help to review, it's easy to reproduce. My system is Fedora-rawhide/RHEL-9,
with upstream mainline linux HEAD=dc912ba91b7e2fa74650a0fc22cccf0e0d50f371.
The generic/617.full output as [3].

Thanks,
Zorro

[1]
FSTYP         -- overlay
PLATFORM      -- Linux/x86_64 dell-xxxx-xxx 6.6.0-rc2+ #1 SMP PREEMPT_DYNAMIC Fri Sep 22 15:41:10 EDT 2023
MKFS_OPTIONS  -- -m crc=1,finobt=1,rmapbt=0,reflink=1,inobtcount=1,bigtime=1 /mnt/xfstests/scratch
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /mnt/xfstests/scratch /mnt/xfstests/scratch/ovl-mnt

generic/617       - output mismatch (see /var/lib/xfstests/results//generic/617.out.bad)
    --- tests/generic/617.out	2023-09-22 16:08:35.444572181 -0400
    +++ /var/lib/xfstests/results//generic/617.out.bad	2023-09-22 19:33:29.240901008 -0400
    @@ -1,2 +1,54 @@
     QA output created by 617
    +uring write bad io length: 0 instead of 8192
    +short write: 0x0 bytes instead of 0x2000
    +LOG DUMP (46 total operations):
    +1(  1 mod 256): FALLOC   0x28c0d thru 0x2953a	(0x92d bytes) EXTENDING
    +2(  2 mod 256): TRUNCATE UP	from 0x2953a to 0x81000
    +3(  3 mod 256): ZERO     0x6f07 thru 0x14790	(0xd88a bytes)
    ...
    (Run 'diff -u /var/lib/xfstests/tests/generic/617.out /var/lib/xfstests/results//generic/617.out.bad'  to see the entire diff)
Ran: generic/617
Failures: generic/617
Failed 1 of 1 tests

[2]
FSTYP         -- overlay
PLATFORM      -- Linux/x86_64 hp-xxxxxx-xx 6.5.0-rc6+ #1 SMP PREEMPT_DYNAMIC Mon Aug 14 12:45:06 UTC 2023
MKFS_OPTIONS  -- /mnt/scratch
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /mnt/scratch /mnt/scratch/ovl-mnt

generic/617        5s
Ran: generic/617
Passed all 1 tests

[3]
/var/lib/xfstests/ltp/fsx -S 0 -U -q -N 20000 -p 200 -o 128000 -l 600000 -r 4096 -t 4096 -w 4096 -Z /mnt/xfstests/test/ovl-mnt/junk
uring write bad io length: 0 instead of 8192
short write: 0x0 bytes instead of 0x2000
LOG DUMP (46 total operations):
1(  1 mod 256): FALLOC   0x28c0d thru 0x2953a	(0x92d bytes) EXTENDING
2(  2 mod 256): TRUNCATE UP	from 0x2953a to 0x81000
3(  3 mod 256): ZERO     0x6f07 thru 0x14790	(0xd88a bytes)
4(  4 mod 256): ZERO     0x4a097 thru 0x5dfc8	(0x13f32 bytes)
5(  5 mod 256): TRUNCATE DOWN	from 0x81000 to 0x10000
6(  6 mod 256): MAPWRITE 0x74000 thru 0x78de7	(0x4de8 bytes)
7(  7 mod 256): SKIPPED (no operation)
8(  8 mod 256): MAPWRITE 0x52000 thru 0x57bf5	(0x5bf6 bytes)
9(  9 mod 256): DEDUPE 0x19000 thru 0x20fff	(0x8000 bytes) to 0x57000 thru 0x5efff
10( 10 mod 256): COPY 0x64000 thru 0x6bfff	(0x8000 bytes) to 0x1c000 thru 0x23fff
11( 11 mod 256): INSERT 0x38000 thru 0x46fff	(0xf000 bytes)
12( 12 mod 256): WRITE    0x16000 thru 0x1cfff	(0x7000 bytes)
13( 13 mod 256): MAPWRITE 0x3f000 thru 0x444d5	(0x54d6 bytes)
14( 14 mod 256): INSERT 0x83000 thru 0x8cfff	(0xa000 bytes)
15( 15 mod 256): COPY 0x54000 thru 0x5dfff	(0xa000 bytes) to 0x6d000 thru 0x76fff
16( 16 mod 256): PUNCH    0x34f3d thru 0x48c45	(0x13d09 bytes)
17( 17 mod 256): FALLOC   0x47bd5 thru 0x5a950	(0x12d7b bytes) INTERIOR
18( 18 mod 256): READ     0x20000 thru 0x3cfff	(0x1d000 bytes)
19( 19 mod 256): READ     0xe000 thru 0x1cfff	(0xf000 bytes)
20( 20 mod 256): MAPREAD  0x70000 thru 0x8d512	(0x1d513 bytes)
21( 21 mod 256): PUNCH    0x12773 thru 0x1f5b1	(0xce3f bytes)
22( 22 mod 256): DEDUPE 0x81000 thru 0x8ffff	(0xf000 bytes) to 0x3b000 thru 0x49fff
23( 23 mod 256): CLONE 0x78000 thru 0x7efff	(0x7000 bytes) to 0x1e000 thru 0x24fff
24( 24 mod 256): MAPREAD  0x1000 thru 0x1b6c1	(0x1a6c2 bytes)
25( 25 mod 256): SKIPPED (no operation)
26( 26 mod 256): FALLOC   0x43b4c thru 0x5ecb7	(0x1b16b bytes) INTERIOR
27( 27 mod 256): SKIPPED (no operation)
28( 28 mod 256): WRITE    0x3000 thru 0x8fff	(0x6000 bytes)
29( 29 mod 256): COPY 0x19000 thru 0x20fff	(0x8000 bytes) to 0x79000 thru 0x80fff
30( 30 mod 256): WRITE    0x19000 thru 0x28fff	(0x10000 bytes)
31( 31 mod 256): DEDUPE 0x3a000 thru 0x3dfff	(0x4000 bytes) to 0x49000 thru 0x4cfff
32( 32 mod 256): ZERO     0x8f290 thru 0x927bf	(0x3530 bytes)
33( 33 mod 256): PUNCH    0x45aec thru 0x58137	(0x1264c bytes)
34( 34 mod 256): SKIPPED (no operation)
35( 35 mod 256): FALLOC   0x5b567 thru 0x613ab	(0x5e44 bytes) INTERIOR
36( 36 mod 256): ZERO     0x1abc7 thru 0x1bbd6	(0x1010 bytes)
37( 37 mod 256): MAPWRITE 0x44000 thru 0x45411	(0x1412 bytes)
38( 38 mod 256): FALLOC   0x3b222 thru 0x4de57	(0x12c35 bytes) INTERIOR
39( 39 mod 256): COLLAPSE 0x1e000 thru 0x20fff	(0x3000 bytes)
40( 40 mod 256): INSERT 0x62000 thru 0x64fff	(0x3000 bytes)
41( 41 mod 256): DEDUPE 0xf000 thru 0x16fff	(0x8000 bytes) to 0x78000 thru 0x7ffff
42( 42 mod 256): WRITE    0x4000 thru 0x12fff	(0xf000 bytes)
43( 43 mod 256): COPY 0x62000 thru 0x79fff	(0x18000 bytes) to 0x2000 thru 0x19fff
44( 44 mod 256): SKIPPED (no operation)
45( 45 mod 256): MAPWRITE 0x22000 thru 0x297c9	(0x77ca bytes)
46( 46 mod 256): WRITE    0x41000 thru 0x42fff	(0x2000 bytes)
Log of operations saved to "/mnt/xfstests/test/ovl-mnt/junk.fsxops"; replay with --replay-ops
Correct content saved for comparison
(maybe hexdump "/mnt/xfstests/test/ovl-mnt/junk" vs "/mnt/xfstests/test/ovl-mnt/junk.fsxgood")

