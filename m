Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B2ABC433EF
	for <linux-unionfs@archiver.kernel.org>; Wed, 30 Mar 2022 15:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348181AbiC3P21 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 11:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348186AbiC3P2X (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 30 Mar 2022 11:28:23 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3BE1AD3A8;
        Wed, 30 Mar 2022 08:26:38 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 84ED768B05; Wed, 30 Mar 2022 17:26:35 +0200 (CEST)
Date:   Wed, 30 Mar 2022 17:26:35 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigo@sdfg.com.ar>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 02/19] exportfs: support idmapped mounts
Message-ID: <20220330152635.GB4835@lst.de>
References: <20220330102409.1290850-1-brauner@kernel.org> <20220330102409.1290850-3-brauner@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330102409.1290850-3-brauner@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Mar 30, 2022 at 12:23:50PM +0200, Christian Brauner wrote:
> Make the two locations where exportfs helpers check permission to lookup
> a given inode idmapped mount aware by switching it to the lookup_one()
> helper. This is a bugfix for the open_by_handle_at() system call which
> doesn't take idmapped mounts into account currently. It's not tied to a
> specific commit so we'll just Cc stable.
> 
> In addition this is required to support idmapped base layers in overlay.
> The overlay filesystem uses exportfs to encode and decode file handles
> for its index=on mount option and when nfs_export=on.

This probably wants a Fixes tag, as without it NFS exporting idmapped
file will give slightly unexpected results.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
