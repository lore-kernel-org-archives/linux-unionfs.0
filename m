From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 0/8] Security: Provide unioned file support
Date: Fri, 19 Jun 2015 09:52:55 +0200
Message-ID: <CAJfpeguZq-1C_hnCcyrW3MCcpP4Bwe+L4gpWaOeJCqa1q8j4Hg@mail.gmail.com>
References: <20150618133215.12722.70352.stgit@warthog.procyon.org.uk>
	<20150619072015.GH17109@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:36722 "EHLO
	mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbbFSHw4 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 19 Jun 2015 03:52:56 -0400
Received: by qkfe185 with SMTP id e185so57168004qkf.3
        for <linux-unionfs@vger.kernel.org>; Fri, 19 Jun 2015 00:52:55 -0700 (PDT)
In-Reply-To: <20150619072015.GH17109@ZenIV.linux.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, sds@tycho.nsa.gov, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, linux-security-module@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>

On Fri, Jun 19, 2015 at 9:20 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Jun 18, 2015 at 02:32:15PM +0100, David Howells wrote:
>>
>> The attached patches provide security support for unioned files where the
>> security involves an object-label-based LSM (such as SELinux) rather than a
>> path-based LSM.
>>
>> The patches can be broken down into a number of sets:
>>
>>  (1) A small patch to drop a lock earlier in overlayfs.  The main VFS patch
>>      touches the same code, so I put this first.
>>
>>  (2) The main VFS patch that makes an open file struct referring to a union
>>      file have ->f_path point to the union/overlay file whilst ->f_inode and
>>      ->f_mapping refer to the subordinate file that does the actual work.
>
> #1 and #2 applied, will be in tomorrow vfs.git#for-next

Brave.

What's going to happen to all those f_path.dentry uses where the
filesystem thinks it's getting its own dentry?

> git grep f_path.dentry | wc -l
171

Thanks,
Miklos
