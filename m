Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86C54C433F5
	for <linux-unionfs@archiver.kernel.org>; Fri,  1 Apr 2022 06:54:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241223AbiDAG4R (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 1 Apr 2022 02:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245753AbiDAG4Q (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 1 Apr 2022 02:56:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D9F97B91
        for <linux-unionfs@vger.kernel.org>; Thu, 31 Mar 2022 23:54:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A803616D2
        for <linux-unionfs@vger.kernel.org>; Fri,  1 Apr 2022 06:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C76C2BBE4;
        Fri,  1 Apr 2022 06:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648796064;
        bh=36wyyi9XUDXNn7jelp9dgsXjYGCMbvis+T/EEDfntcY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qp+5PBw4KpP2nm850yFNboGz8GmKrgpf7zywC3RWiq7mOvay1ACXoqizcoI2wsYKn
         CppiE49qSgP9K5Dj3eJYnZxUo62rHI9vD5xYsfu//0MlHWEIvvzTpSe2MvjJ8Q2G8s
         aIfWLu4HkxiB8LoupZhmcQE9YIcBVD3VfvgbJYmVGjLq9w6AigX7xU+MUr1qaMuvaP
         oxV+W/MsGtY9F/vX5r9tMXvOxuBhb5u3GI88JGmWFqEDgXeYVPaJC7NJsO3vimCiBT
         sH5ugY7AaGo+Jx867iJB9yRzFhSCcn62omgCM8vEhzF6RsRFUdnxYDHJKD5VHp4kbN
         hmD/+A/wuVv6w==
Date:   Fri, 1 Apr 2022 08:54:19 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        linux-unionfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigo@sdfg.com.ar>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?utf-8?B?U3TDqXBoYW5l?= Graber <stgraber@ubuntu.com>
Subject: Re: [PATCH v3 00/19] overlay: support idmapped layers
Message-ID: <20220401065419.5lnrqfquxwhowxfd@wittgenstein>
References: <20220331112318.1377494-1-brauner@kernel.org>
 <YkX7fdIE+B3Z+Ze2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YkX7fdIE+B3Z+Ze2@redhat.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Mar 31, 2022 at 03:05:33PM -0400, Vivek Goyal wrote:
> On Thu, Mar 31, 2022 at 01:22:58PM +0200, Christian Brauner wrote:
> 
> Hi Christian,
> 
> Following the example in here.
> 
> https://gitlab.com/brauner/fs.idmapped.overlay.xfstests.output/-/blob/main/manual.test.instructions
> 
> sudo mount-idmapped --map-mount b:10000000:0:100000000000 ./my-tmp /mnt
> 
> Initially I could not even create idmapped mounts. I had to specify
> full path and then it works. But relative path (./my-tmp) does not
> work.
> 
> For example this works.
> 
> /root/git/xfstests-dev/src/idmapped-mounts/mount-idmapped --map-mount b:10000000:0:100000000000 /root/idmapped-testing/my-tmp /root/idmapped-testing/shifted
> 
> But this fails.
> 
> $ /root/git/xfstests-dev/src/idmapped-mounts/mount-idmapped --map-mount b:10000000:0:100000000000 ./my-tmp shifted
> 
> Bad file descriptor - Failed to open ./my-tmp
> 
> Not sure if this is a limitation of idmapped-mounts or this is expected.

Heh, this is certainly not a limitation of idmapped mounts. :D
It is a limitation of the test binary.

Specifically, if you care it does:

	source = new_argv[0];
	target = new_argv[1];

	fd_tree = sys_open_tree(-EBADF, source,
			        OPEN_TREE_CLONE |
			        OPEN_TREE_CLOEXEC |
			        AT_EMPTY_PATH |
			        (recursive ? AT_RECURSIVE : 0));

if you specify ./my-tmp then you get:

open_tree(-9, "./my-dir", OPEN_TREE_CLONE|OPEN_TREE_CLOEXEC|AT_EMPTY_PATH) = -1 EBADF (Bad file descriptor)

which means ./my-dir is taken relative to -9 which lands you in

static const char *path_init(struct nameidata *nd, unsigned flags)
[...]
		struct fd f = fdget_raw(nd->dfd);
		struct dentry *dentry;

		if (!f.file)
			return ERR_PTR(-EBADF);
[...]

For this to work we'd need to detect a relative path and pass AT_FDCWD.

But that tool was really just intended for xfstests so I was lazy enough
to force people to specify full paths.
