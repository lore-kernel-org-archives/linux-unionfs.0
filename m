Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB7E2CDB474
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Oct 2023 08:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbjJPIDh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 16 Oct 2023 04:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbjJPIDg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Oct 2023 04:03:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D83DE
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Oct 2023 01:03:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8631C433C7;
        Mon, 16 Oct 2023 08:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697443415;
        bh=HmynXz1SguSM2RHoFlCQRSe7GtTgywzXJd4ry0/TFRk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V4N2Fd5pnVz5QBPvDOLXJ6yRC1aCsv1gKMAx04K5l/I+HZ9HjLIixnT95sKvHZl0g
         U/vRjMEvV8ScwqxAepe1fN//7UVcflFdy5itvNlgASnMWfblLpRRZ4cpw9V0nV9dcm
         OCYvx22cuEGqHN7NJ/sesadVyQsZ2pVvCMYdAi0HarH3YaVXet9faLt9O2ZSwc37Nx
         aqIitsFsVKYoA6zTI+7Hlix3Glc9CenfyS7ewX1COAF553Z5ep1ICwP7s3v7AI/42b
         Ovg8NJCIDIW7gcuU/ifpxm0/oxHiOo2P4rQhPKx0cL/dsks3vWAN70MK5fENiJsmJH
         yBNViW7aDDUbQ==
Date:   Mon, 16 Oct 2023 10:03:30 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] ovl: temporarily disable appending lowedirs
Message-ID: <20231016-siehst-vorfreude-f4a681ed4efd@brauner>
References: <20231014195353.2103095-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231014195353.2103095-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Oct 14, 2023 at 10:53:53PM +0300, Amir Goldstein wrote:
> Kernel v6.5 converted overlayfs to new mount api.
> As an added bonus, it also added a feature to allow appending lowerdirs
> using lowerdir=:/lower2,lowerdir=::/data3 syntax.
> 
> This new syntax has raised some concerns regarding escaping of colons.
> We decided to try and disable this syntax, which hasn't been in the wild
> for so long and introduce it again in 6.7 using explicit mount options
> lowerdir+=/lower2,datadir+=/data3.
> 
> Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
> Link: https://lore.kernel.org/r/CAJfpegsr3A4YgF2YBevWa6n3=AcP7hNndG6EPMu3ncvV-AM71A@mail.gmail.com/
> Fixes: b36a5780cb44 ("ovl: modify layer parameter parsing")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

Acked-by: Christian Brauner <brauner@kernel.org>
