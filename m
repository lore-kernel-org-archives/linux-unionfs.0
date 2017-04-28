From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 1/5] overlay/017: silence test output
Date: Fri, 28 Apr 2017 14:50:51 +0800
Message-ID: <20170428065051.GO26397@eguan.usersys.redhat.com>
References: <1493305775-12559-1-git-send-email-amir73il@gmail.com>
 <1493305775-12559-2-git-send-email-amir73il@gmail.com>
 <20170428053633.GL26397@eguan.usersys.redhat.com>
 <CAOQ4uxiQ__f4eoZT+qyszHPK7KwuW+NbDfFz3E=d6+nkSEKVRg@mail.gmail.com>
 <20170428055035.GN26397@eguan.usersys.redhat.com>
 <CAOQ4uxisjtWLnHxXg+PbaJjFOmY7ZFEkF+ggsWB+54FSHvMLjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44836 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938590AbdD1Guy (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 28 Apr 2017 02:50:54 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxisjtWLnHxXg+PbaJjFOmY7ZFEkF+ggsWB+54FSHvMLjA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Fri, Apr 28, 2017 at 09:34:18AM +0300, Amir Goldstein wrote:
> In your setup does strace find `pwd` -maxdepth 1 -inum 3932421
> show newfstatat  for each inode?
> It should be doing stat only for dirs according to the code and
> Enabled features of find --version.
> Not sure why it does newfstatat for every inode on my kvm machine...
> 
> Amir.

My find only calls newfstatat on dirs, find version
findutils-4.5.11-5.el7.x86_64

# strace find `pwd` -maxdepth 1 -inum 3932421 2>&1 | grep newfstatat
newfstatat(AT_FDCWD, "/root/xfstests", {st_mode=S_IFDIR|0755, st_size=4096, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(AT_FDCWD, "/root/xfstests", {st_mode=S_IFDIR|0755, st_size=4096, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(5, "testlogs", {st_mode=S_IFDIR|0755, st_size=4096, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(5, "tests", {st_mode=S_IFDIR|0775, st_size=4096, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(5, "btrfsstress-v5", {st_mode=S_IFDIR|0755, st_size=4096, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(5, "testpatch", {st_mode=S_IFDIR|0755, st_size=4096, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(5, "btrfsstress-v4", {st_mode=S_IFDIR|0755, st_size=4096, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(5, "include", {st_mode=S_IFDIR|0775, st_size=4096, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(5, "ltp", {st_mode=S_IFDIR|0775, st_size=4096, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(5, "autom4te.cache", {st_mode=S_IFDIR|0755, st_size=4096, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(5, "btrfsstress", {st_mode=S_IFDIR|0755, st_size=4096, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(5, "crash", {st_mode=S_IFDIR|0775, st_size=4096, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(5, "build", {st_mode=S_IFDIR|0775, st_size=4096, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(5, "tools", {st_mode=S_IFDIR|0775, st_size=4096, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(5, "lib", {st_mode=S_IFDIR|0775, st_size=4096, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(5, "btrfsstress-v2", {st_mode=S_IFDIR|0755, st_size=4096, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(5, ".git", {st_mode=S_IFDIR|0775, st_size=4096, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(5, "configs", {st_mode=S_IFDIR|0775, st_size=4096, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(5, "dmapi", {st_mode=S_IFDIR|0775, st_size=4096, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(5, "patches", {st_mode=S_IFDIR|0755, st_size=4096, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(5, "btrfsstress-v3", {st_mode=S_IFDIR|0755, st_size=4096, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(5, "src", {st_mode=S_IFDIR|0775, st_size=12288, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(5, "results", {st_mode=S_IFDIR|0755, st_size=4096, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(5, "m4", {st_mode=S_IFDIR|0775, st_size=4096, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(5, "doc", {st_mode=S_IFDIR|0775, st_size=4096, ...}, AT_SYMLINK_NOFOLLOW) = 0
newfstatat(5, "common", {st_mode=S_IFDIR|0775, st_size=4096, ...}, AT_SYMLINK_NOFOLLOW) = 0

Eryu
