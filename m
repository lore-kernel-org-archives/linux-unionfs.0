Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E41C77B7A
	for <linux-unionfs@archiver.kernel.org>; Thu, 25 May 2023 07:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235439AbjEYHFE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 25 May 2023 03:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234092AbjEYHFC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 25 May 2023 03:05:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2C5E45;
        Thu, 25 May 2023 00:05:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B75096413B;
        Thu, 25 May 2023 07:05:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA734C433D2;
        Thu, 25 May 2023 07:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684998300;
        bh=tjm/CJuriXuU00o75/1sEwBZXk+OViust+9WJDb5A5c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ccs7KGoayAFNeto65PtRx1Ee6m3WQ9UgZ0IEcbq0OM/q++MprjwDpfWJX4tq+8EWO
         VocaisKTxV9xMhV6dbpD3GSkysIOyYOvDnK0q+cpoD+aIdfXadFgdcLTWupXJXZycl
         QbQCTIb7OfWVdrRXeX6TW2uZ149GXKZlkuJRnDysIuCyDSXj5/fYwqkP4dZo7eZvCp
         fswpZaOYHhxPI3jBS7ZnHk7EMaSrj4+M/eqGOaIsWjNf1VP0g/ItSK2kCxnjhOW6QA
         ah2FngXWOqQOJ9lN7LVW2EzHABPRZ2vMmOeNvF+0kPw9UF0DzAlYtugHmKX8kfKsJT
         FA/LKiYHNuNtQ==
Date:   Thu, 25 May 2023 09:04:55 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-unionfs@vger.kernel.org, fstests@vger.kernel.org,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] Skip weird open dir tests
Message-ID: <20230525-sturm-gefischt-bbbb64c6fe90@brauner>
References: <20230524182736.953960-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230524182736.953960-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, May 24, 2023 at 09:27:36PM +0300, Amir Goldstein wrote:
> After kernel commit 43b450632676 ("open: return EINVAL for O_DIRECTORY
>  | O_CREAT") the results of this test depends on the tested kernel
> version.
> 
> This is not an overlayfs specific test, so skip it.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

Thanks for fixing this,
Acked-by: Christian Brauner <brauner@kernel.org>
