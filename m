Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15C8EEB64DD
	for <linux-unionfs@archiver.kernel.org>; Sun, 25 Jun 2023 13:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjFYNuo (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 25 Jun 2023 09:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjFYNum (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 25 Jun 2023 09:50:42 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBBE6E43;
        Sun, 25 Jun 2023 06:50:40 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-312863a983fso2749821f8f.2;
        Sun, 25 Jun 2023 06:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687701039; x=1690293039;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WldIkkd0DUzDS6YM6BjJZXM9ardNRCl4oAVSE2tn3/A=;
        b=Ai3CV4c/S0nxDOXjwZf51TSdsvodpFmqdrnB3adGUncjBtZ1dOrWGQSxb7kIE4UCac
         ys5h9yBSBkv5hBJywlhPh/QxRkGzic5DBp2pPwDNev3BQCrGV0QLd0i3sdDXDg8SIZRJ
         OGucUYsujXeuW2JqiKjciFnTAJmAwKZmnQLZ03Vfurewyl8iOE5zBR75N/2m37GQbadt
         YCF+H4RhAGeb7Qt0mO6FlQuENb93pzv+nq+ClNr25ECWp/GRKtKCExocWc//p4E43u9n
         +Ipsk2Xzs5aay91mMpOEcCKrdCcf13AETTpUez3+Vt2joxr6+HLyNS9PptsrVQvM4mKe
         KtAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687701039; x=1690293039;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WldIkkd0DUzDS6YM6BjJZXM9ardNRCl4oAVSE2tn3/A=;
        b=Ocobe3Nc5EgsJb7/WHtC7gSq4TImibOQfS48QWHwGiZME0mxPp4L83Yre7Rr3g6AGO
         n2vejGTulKvLgOABUqo/JPe08KSep2rsoxUX4khXJCJ1FG8mpfTbl0vT/D81lUkCPZLM
         H9AYY6HhWJwzfwnbGKvIpgebW/ZAvGVgR+/3XPUGPIY1lX55hQN/vF/96zElf5HOwsIU
         Lcl9uDjdV9+Koptc8mI8EnmhWC0iHAlOWXodQq1+ZPEzWg8feS6N9WJ4GAWXH/yUBQh4
         gEEf8tXdg82Mo0d0J0I/+64IPy1yrWHXxosZewFJs/ABBybvnbQV+ladcnmFfgP2ECbY
         pshg==
X-Gm-Message-State: AC+VfDyniaCVP9LQQ/a81JEwyBh0jIUOZpeUgrgUJYmYXyvBOZ0UfdCc
        FHgUBzlsURm8cuO4wxOhuaI=
X-Google-Smtp-Source: ACHHUZ6l7faU06g3GQ2wuNPLEXwja/oEt6NOpAoHB8UhfBs0zOsENod9rwbIQDQSW4q42TxgLb1B8Q==
X-Received: by 2002:a5d:4f07:0:b0:313:e036:882a with SMTP id c7-20020a5d4f07000000b00313e036882amr3940611wru.10.1687701038996;
        Sun, 25 Jun 2023 06:50:38 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id b3-20020adff243000000b003112b38fe90sm4667166wrp.79.2023.06.25.06.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jun 2023 06:50:38 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Eric Biggers <ebiggers@google.com>,
        Alexander Larsson <alexl@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        fstests@vger.kernel.org, linux-unionfs@vger.kernel.org
Subject: [PATCH 0/3] fstests-bld overlayfs updates
Date:   Sun, 25 Jun 2023 16:50:30 +0300
Message-Id: <20230625135033.3205742-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Ted,

The first patch enables testing the new overlayfs verity feature,
which is NOT the same as saying that overlayfs supports fsverity.

The other two are cleanups and fixes to overlayfs configs.

Thanks,
Amir.

Amir Goldstein (3):
  test-appliance: enable verity for testing overlay over ext4
  test-appliance: remove redudant overlay configs
  test-appliance: skip overlayfs tests from base fs exclude list

 .../files/root/fs/overlay/cfg/large-ext4           | 14 --------------
 test-appliance/files/root/fs/overlay/cfg/large-xfs | 14 --------------
 .../files/root/fs/overlay/cfg/small-ext4           | 14 --------------
 .../files/root/fs/overlay/cfg/small-ext4.exclude   |  1 -
 test-appliance/files/root/fs/overlay/cfg/small-xfs | 14 --------------
 .../files/root/fs/overlay/cfg/small-xfs.exclude    |  1 -
 test-appliance/files/root/fs/overlay/config        |  2 +-
 test-appliance/files/root/runtests.sh              |  1 +
 8 files changed, 2 insertions(+), 59 deletions(-)
 delete mode 100644 test-appliance/files/root/fs/overlay/cfg/large-ext4
 delete mode 100644 test-appliance/files/root/fs/overlay/cfg/large-xfs
 delete mode 100644 test-appliance/files/root/fs/overlay/cfg/small-ext4
 delete mode 100644 test-appliance/files/root/fs/overlay/cfg/small-ext4.exclude
 delete mode 100644 test-appliance/files/root/fs/overlay/cfg/small-xfs
 delete mode 100644 test-appliance/files/root/fs/overlay/cfg/small-xfs.exclude

-- 
2.34.1

