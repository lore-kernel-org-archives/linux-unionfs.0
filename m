Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C51ADEB64D7
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jun 2023 09:21:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbjFTJV6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 05:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbjFTJV5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jun 2023 05:21:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FB8CE
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 02:21:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69B8C60F73
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 09:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018E2C433C8;
        Tue, 20 Jun 2023 09:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687252915;
        bh=JFkUNqLu6CarrMrOr5AHL9MV2G0DQnETErvjJoHtDmQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cChJsM2B4wP3cTH/gvndHBOm8qBwOf/7qIvboBkSz+aWN3ORv88MnuZ65iSKMha28
         u69etg+2CATdlbJspVJ9GCEVDYSsVfb/KrBL0vRj3EFQ1F/n81z8faKLhqtolGYwrd
         fMoDvFtfLsjb7zkskMcW6+4beRWHTwwMQExFVvG3N8WUK28rBEvpcSKeSrIg0vktHv
         c3rSSfcbriMrCtRFQy7l+2AA9ohJjeNizfv9b1SRuWaKyQqWPguOFT0N9DQRhM6Qxr
         stYsxpZcfgHnJYS+dZNX3XNk2tGH35QImrVquhOO7Z0oRKB8Ir8a3Y4eq0giu4/PC3
         PYlREf9jx/nGA==
Date:   Tue, 20 Jun 2023 11:21:52 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v2 3/5] ovl: pass ovl_fs to xino helpers
Message-ID: <20230620-einzeln-abermals-22d7071f9e73@brauner>
References: <20230617084702.2468470-1-amir73il@gmail.com>
 <20230617084702.2468470-4-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230617084702.2468470-4-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Jun 17, 2023 at 11:47:00AM +0300, Amir Goldstein wrote:
> Internal ovl methods should use ovl_fs and not sb as much as
> possible.
> 
> Use a constant_table to translate from enum xino mode to string
> in preperation for new mount api option parsing.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

Looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>
