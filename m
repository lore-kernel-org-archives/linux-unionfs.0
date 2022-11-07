Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2743C433FE
	for <linux-unionfs@archiver.kernel.org>; Mon,  7 Nov 2022 04:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiKGE3l (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 6 Nov 2022 23:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbiKGE3k (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 6 Nov 2022 23:29:40 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FC8A45F
        for <linux-unionfs@vger.kernel.org>; Sun,  6 Nov 2022 20:29:38 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id l22-20020a17090a3f1600b00212fbbcfb78so13376449pjc.3
        for <linux-unionfs@vger.kernel.org>; Sun, 06 Nov 2022 20:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1hXEdKrSfJea2pwv7vtnqLeuRUkEVP2ciAxEoielt5Y=;
        b=l37z8Mfi/ZJFWxBiVEDW66FYfBRNBih7l78+hE82DbJcwFDud0vXRthysO5az2JO5b
         k1qNVCt2+biJrAtRlrRriie4ZzTysiRPmozX/i6HLd42by4qA1u4Acke4CA8wfXU1Of3
         6Eq4TNJyABIMSec6DaKJkyOpok0u50UgkwSn5ppr8oaAWYSN5YmEeJs4zeCLlWapmsKe
         xZOwjeOtORRbvKexql6hQg5Z0MdPHf2pxw/tnxRvC7LxaonaTsGbpPehSdtzjZtSEz7F
         o42hKthZAViZuGtOifVAYk/6RkXuGNBQwkW8gYMu1zgDVgHvJslB+6xquUA28IbhDyd2
         WeKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1hXEdKrSfJea2pwv7vtnqLeuRUkEVP2ciAxEoielt5Y=;
        b=RyJEfg1Qrs9rPX64RdNhxe8Dgyr2HRxYaaFYEILw8TKuJQ/3SHlUlcI9oycHa553pb
         te5GMv9IWJTj0pXdURX97X9lD0PVpW5u+PI12VbT4BwNu0iHalqq37ZuwwiWEJsN3JQt
         hW7kd2ULUl4EbO3i+NgKvKeQCO8+bpLhwfxetA8f7CrDyOBRgVzIPrWIcrL+tfAxbVv8
         +I+cTLV9pdeZWkRC4dQN7WRt0IW3+k/Mu4uPwczPw/5LHJHyoq0tN/Gk4LEx37tiVN/S
         SDPiFTtEvyyfVrNOo0VXjju8KVnHWlhFfWLrvaSaTCsoo9mS+29pFt9oFXedYknwmlds
         adgw==
X-Gm-Message-State: ACrzQf260YOk6IBII8KrULaOyoUJqsU0LSdMjApDdf2+qrveSDAWdx1b
        jciBJg/SimIA6ZDajxlBSW1+rwJRXM0=
X-Google-Smtp-Source: AMsMyM66dC5Ib9NbOzitNz41Z7lmlnZwx0wSBaxZtxPb9dZ3GCscnpcdJwxX0UqSH2uzGGhUMBDLwQ==
X-Received: by 2002:a17:90b:1490:b0:212:68bf:fcc5 with SMTP id js16-20020a17090b149000b0021268bffcc5mr32157673pjb.52.1667795378381;
        Sun, 06 Nov 2022 20:29:38 -0800 (PST)
Received: from ubuntu ([210.99.119.32])
        by smtp.gmail.com with ESMTPSA id k17-20020a170902c41100b00186a6b6350esm3861457plk.268.2022.11.06.20.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Nov 2022 20:29:36 -0800 (PST)
Date:   Sun, 6 Nov 2022 20:29:32 -0800
From:   "YoungJun.Park" <her0gyugyu@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Subject: Question about ESTALE error whene deleting upper directory file.
Message-ID: <20221107042932.GB1843153@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Here is my curious scenario.

1. create a file on overlayfs.
2. delete a file on upper directory.
3. can see file contents using read sys call. (may file operations all success)
4. cannot remove, rename. it return -ESTALE error (may inode operations fail)

I understand this scenario onto the code level.
But I don't understand this situation itself.

I found a overlay kernel docs and it comments 
Changes to underlying filesystems section

...
Changes to the underlying filesystems while part of a mounted overlay filesystem are not allowed. 
If the underlying filesystem is changed, the behavior of the overlay is undefined, 
though it will not result in a crash or deadlock.
....

So here is my question (may it is suggestion)

1. underlying file system change is not allowed, then how about implementing shadow upper directory from user? 
2. if read, write system call is allowed, how about changing remove, rename(and more I does not percept) operation success?

Best Regards.
