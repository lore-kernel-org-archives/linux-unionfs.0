Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E67D4C433EF
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Apr 2022 14:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348567AbiD1OvY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 10:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbiD1OvV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Apr 2022 10:51:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F016B0D2E
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Apr 2022 07:48:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18A91B82D92
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Apr 2022 14:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94F7C385A0;
        Thu, 28 Apr 2022 14:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651157284;
        bh=T//O2YwSoUfwlPmo1xOk77wlg588jiCgSqdWhnRQFF8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SlSVDbDELUMAi1oO49koPfgqUIK2xzSzbl7LPtEYtxA7zXIXlwaqbjOEGoxApujel
         gBHpClOVOC/OTnCWb+5yqDMITklUFk3EJpZvC46w0p4UVkw/VkmWj3FDdVjMYHmhxZ
         1pqUsRNUdUyFDzbPtN5kvsZJqZo3sq7YMEEzk1/7746hWkeYQTGSDc/XnQyfRNL/fx
         rBheRXy1fq4nINAuYKf1CDcQZ9EEbXi9mcSVuqzjQWTGBqfK/cDvqYwwwDgy7RUjrn
         FxrdhmQM73EINAzQIiEu4eAwSYa7F2fBtTTBtpKaMiFVbnsexdpXBBpuHATeyw6Sa5
         iEG9Ku2AXZ9vg==
Date:   Thu, 28 Apr 2022 16:47:58 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigo@sdfg.com.ar>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?utf-8?B?U3TDqXBoYW5l?= Graber <stgraber@ubuntu.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v5 00/19] overlay: support idmapped layers
Message-ID: <20220428144758.iauivmnkm6mm2bz3@wittgenstein>
References: <20220407112157.1775081-1-brauner@kernel.org>
 <CAJfpegvFNpruOPCXp-HfgMgw5n1Mj5bj7J0JMeAXeMa=587CsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJfpegvFNpruOPCXp-HfgMgw5n1Mj5bj7J0JMeAXeMa=587CsA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 28, 2022 at 04:39:27PM +0200, Miklos Szeredi wrote:
> On Thu, 7 Apr 2022 at 13:22, Christian Brauner <brauner@kernel.org> wrote:
> >
> > From: "Christian Brauner (Microsoft)" <brauner@kernel.org>
> >
> > Hey,
> >
> > This adds support for mounting overlay on top of idmapped layers.
> 
> Pushed updated series to:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git#ovl-idmap
> 
> It's mostly just cleanups.  Survives quick xfstests, but please also
> test that I haven't broken the new functionality.

Thank you. I'll keep an eye out and I'm of course around going forward.
Note, I'll be traveling starting early Saturday and there might be a
slight delay in my responses for at least next week.

Thanks!
Christian
