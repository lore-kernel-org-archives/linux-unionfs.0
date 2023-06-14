Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEA38EB64D9
	for <linux-unionfs@archiver.kernel.org>; Wed, 14 Jun 2023 07:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238021AbjFNHHe (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235090AbjFNHHc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Jun 2023 03:07:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD1098
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jun 2023 00:07:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B98BE637B3
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jun 2023 07:07:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7B8C433C8;
        Wed, 14 Jun 2023 07:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686726451;
        bh=ymwHR6OBy3JNQUxvWFBdY4Fl+/JpDBW19S2PSJtJeO0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OR07Fh5Pt6pyzDY33kMMYrvWAFcpNj3vXTxkOBF2n+PGXVtVfxxT90X90RSgy4oTf
         /IQRYLJ+jgF7Fpy+TxeOAU30OchLYcab89HwLqdzDNINJQfRDKuXCFSbSi+4vusQ0z
         CMx6AxaT9sODwLVFgx+Zq8Kc3KniOQbu5gvLV3RXVVpIgey2wJRzjxEdFyM1RQLNQI
         t2+ETXTrNAiHj6chWCdBQ6VYOfvIkrN5NCoAWzCjhQ3EYnBZngeF5ZWlnMXLGQck2i
         4UHpT86PwsD5NjSKN3O0NY6hqU3zVjj19eve1LflxsrOwoigh4DphffP2A2d2BM/KY
         OxwXTUWw2V11g==
Date:   Wed, 14 Jun 2023 00:07:29 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Alexander Larsson <alexl@redhat.com>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, tytso@mit.edu,
        fsverity@lists.linux.dev
Subject: Re: [PATCH v3 0/4] ovl: Add support for fs-verity checking of
 lowerdata
Message-ID: <20230614070729.GB1146@sol.localdomain>
References: <cover.1686565330.git.alexl@redhat.com>
 <CAOQ4uxgmV1KKCeq8=8FPkAciwqPpz8JiSM8WEuxDaZbVuYcQ7Q@mail.gmail.com>
 <CAL7ro1EiYOOOqexrKy+UXRzmpGyCaNec3+LHGxnA0YfmoMDN3A@mail.gmail.com>
 <CAL7ro1FKwgUY4e7N_vYi0cFsuVx6St0-oKvcBkiRFnzLH8D1eQ@mail.gmail.com>
 <CAOQ4uxgVnv7wtwFZaBnEotFCwQD1EZcSK2KW4K4vRD8d9fzCiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgVnv7wtwFZaBnEotFCwQD1EZcSK2KW4K4vRD8d9fzCiw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jun 14, 2023 at 09:14:10AM +0300, Amir Goldstein wrote:
> What do I need to do in order to enable verity on ext4 besides
> enabling FS_VERITY in the kernel?
> 
> I'm getting these on verity tests on ext4 in the default 4k config.
> _require_scratch_verity() doesn't mention any requirement other
> that 4K blocks and extent format files.
> 
> Thanks,
> Amir.
> 
> BEGIN TEST 4k (10 tests): Ext4 4k block Wed Jun 14 06:04:25 UTC 2023
> DEVICE: /dev/vdb
> EXT_MKFS_OPTIONS: -b 4096
> EXT_MOUNT_OPTIONS: -o block_validity
> FSTYP         -- ext4
> PLATFORM      -- Linux/x86_64 kvm-xfstests
> 6.4.0-rc2-xfstests-00026-g35774ba7f07c #1596 SMP PREEMPT_DYNAMIC Tue
> Jun 13 18:16:59 IDT 2023
> MKFS_OPTIONS  -- -F -q -b 4096 /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc
> 
> generic/572        [06:04:42] [06:04:47] [not run]
> generic/572 -- ext4 verity isn't usable by default with these mkfs options
> ...

I don't know why it's not working for you.  Is there anything helpful in
/results/ext4/results-4k/generic/572.full?

- Eric
