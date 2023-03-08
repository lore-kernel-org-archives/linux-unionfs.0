Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80EE3C742A7
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Mar 2023 15:30:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbjCHPaP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 10:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbjCHP3y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Mar 2023 10:29:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E915474A41
        for <linux-unionfs@vger.kernel.org>; Wed,  8 Mar 2023 07:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678289346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=+0LcXfzuApIChf/bYZ6JaLLsty8097OdMTZqqjVU8UA=;
        b=FmFFpwaDKq53B8N2XFRybtaopm+dquk3ACPukLv2RQbYnYLlBvbnkBTd2f5zpZsLX4KIF5
        +L+LuD483ypiHhtstGVxq6aQq/HXC4sd0x0rYLFL1td6d/FKA0XS9ubkHP+dPwh32HgrgF
        ryDkys8ZnEswtxDxTjh0FGstS4JnDWs=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-378-fCLdJsvvPhiWhii4qKDRYg-1; Wed, 08 Mar 2023 10:29:04 -0500
X-MC-Unique: fCLdJsvvPhiWhii4qKDRYg-1
Received: by mail-io1-f71.google.com with SMTP id s1-20020a6bd301000000b0073e7646594aso8820336iob.8
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Mar 2023 07:29:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678289344;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+0LcXfzuApIChf/bYZ6JaLLsty8097OdMTZqqjVU8UA=;
        b=fOaQGgqxoA1q6qegq2Zb/s8q4M93YJqiZ3qN/q7w0JVyf9yIVSXa0alZE8dGqbr0Lr
         TloDl3tlDP/rZC9dxi00JV1R7W0tgpKfVjI58jdc0gumKMiWnccLAqcUYOS8qs+DT5y+
         PTmnN/zT3th/l/BwoqzZ/s6Fo0+S9ezY5/y3cgX1UNYCLtn4AWn0oqAsr/XTguOQekXF
         7/x9M64K1j2TbH8+4nbmNIuGc6k4eLUEvfdEf4ksa0agOJnn03AC2lZySbdV//91h3yV
         PlIreendYz2i/Lbr8DYiIpVRlKV3c303TkQ86ftiqWiwoIlSyAKd85VPo8W5G1fNvlf1
         0qeA==
X-Gm-Message-State: AO0yUKVmNnsgYxAY0ULcR2E3oltjR6o/49dnn2g6m0M9nX/1atl/GIcc
        v7NLhrlBgEKECndgTXEs73UIeHNNX22YifQeBw0CUfwC48fuvTI0WS8qEHfdTA5kRm54s0ojCvO
        +5NsO5zddNfHAbvFhzPJEXRXE4QKnYAGsB1K3fL0A1Q==
X-Received: by 2002:a6b:ef18:0:b0:745:dfde:ecec with SMTP id k24-20020a6bef18000000b00745dfdeececmr8536747ioh.1.1678289343958;
        Wed, 08 Mar 2023 07:29:03 -0800 (PST)
X-Google-Smtp-Source: AK7set/WVCYzqLPmpgQ6zClEcdMuRUn7JOfTlrBeabEyoosrsZf/PzBA+qDsB1nh2lqJy7B/qVkmwGVgLRRgSonji5U=
X-Received: by 2002:a6b:ef18:0:b0:745:dfde:ecec with SMTP id
 k24-20020a6bef18000000b00745dfdeececmr8536743ioh.1.1678289343739; Wed, 08 Mar
 2023 07:29:03 -0800 (PST)
MIME-Version: 1.0
From:   Alexander Larsson <alexl@redhat.com>
Date:   Wed, 8 Mar 2023 16:28:52 +0100
Message-ID: <CAL7ro1GQcs28kT+_2M5JQZoUN6KHYmA85ouiwjj6JU+1=C-q4g@mail.gmail.com>
Subject: WIP: verity support for overlayfs
To:     Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

As was recently discussed in the various threads about composefs we
want the ability to specify a fs-verity digest for metacopy files,
such that the lower file used for the data is guaranteed to have the
specified digest.

I wrote an initial version of this here:

  https://github.com/alexlarsson/linux/tree/overlay-verity

I would like some feedback on this approach. Does it make sense?

For context, here is the main commit text:

This adds support for a new overlay xattr "overlay.verity", which
contains a fs-verity digest. This is used for metacopy files, and
whenever the lowerdata file is accessed overlayfs can verify that
the data file fs-verity digest matches the expected one.

By default this is ignored, but if the mount option "verity_policy" is
set to "validate" or "require", then all accesses validate any
specified digest. If you use "require" it additionally fails to access
metacopy file if the verity xattr is missing.

The digest is validated during ovl_open() as well as when the lower file
is copied up. Additionally the overlay.verity xattr is copied to the
upper file during a metacopy operation, in order to later do the validation
of the digest when the copy-up happens.

The primary usecase of this is to use a overlay mount with two lower
directories, the lower being a shared content-addressed-storage
containing fs-verity enabled files, and the upper being a read-only
filesystem (such as erofs) containing metacopy files with the redirect
xattr set pointing into the lower cas storage, as well as the verity
xattr. If this is combined with fs-verity or dm-verify for the
read-only filesystem then the entire mount is validated, even though
the backing files are shared between different images.

-- 
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

