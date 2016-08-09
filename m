From: Paul Moore <paul@paul-moore.com>
Subject: Re: [RFC PATCH 0/9][V3] Overlayfs SELinux Support
Date: Mon, 8 Aug 2016 21:19:39 -0400
Message-ID: <CAHC9VhSPj61__P=esyYHhEfQyGKBLZjcoPi1QBFbeRdA2qdNeA@mail.gmail.com>
References: <1468421095-22322-1-git-send-email-vgoyal@redhat.com> <CAHC9VhR7YM+VPXVO=no3bDsj4w5HZz1DiJZR5XajCEfMSYF6=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33017 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbcHIBTl (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 8 Aug 2016 21:19:41 -0400
Received: by mail-oi0-f66.google.com with SMTP id s207so6933659oie.0
        for <linux-unionfs@vger.kernel.org>; Mon, 08 Aug 2016 18:19:41 -0700 (PDT)
In-Reply-To: <CAHC9VhR7YM+VPXVO=no3bDsj4w5HZz1DiJZR5XajCEfMSYF6=g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>, miklos@szeredi.hu, Stephen Smalley <sds@tycho.nsa.gov>, Dan Walsh <dwalsh@redhat.com>
Cc: Paul Moore <pmoore@redhat.com>, James Morris <jmorris@namei.org>, casey@schaufler-ca.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org, dhowells@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org

On Thu, Jul 21, 2016 at 5:16 PM, Paul Moore <paul@paul-moore.com> wrote:
> On Wed, Jul 13, 2016 at 10:44 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> Hi All,
>>
>> Please find attached the V3 of patches. Changes since V2 are as follows.
>>
>> - Fixed the build issue with CONFIG_SECURITY=n.
>>
>> - Dan Walsh was writing more tests for selinux-testsuite and noted couple
>>   of issues. I have fixed those issues and added two more patches in series.
>>
>>   1. We are resetting MAY_WRITE check for lower inode assuming file will
>>      be coiped up. But this is not true for special_file() as these files
>>      are not copied up. So checks should not be reset in case of special
>>      file.
>>
>>   2. We are resetting MAY_WRITE check for lower inode assuming file will
>>      be copied up. But this also should mean that mounter has permission
>>      to MAY_READ lower file for copy up to succeed. So add MAY_READ
>>      check while resetting MAY_WRITE.
>>
>> Original description of patches follows.
>>
>> Following are RFC patches to support SELinux with overlayfs. I started
>> with David Howells's latest posting on this topic and started modifying
>> patches. These patches apply on top of overlayfs-next branch of miklos
>> vfs git tree.
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next
>>
>> These patches can be pulled from my branch too.
>>
>> https://github.com/rhvgoyal/linux/commits/overlayfs-selinux-mounter-next
>>
>> Thanks to Dan Walsh, Stephen Smalley and Miklos Szeredi for numerous
>> conversation and ideas in helping figuring out what one reasonable
>> implementation might look like.
>>
>> Dan Walsh has been writing tests for selinux overlayfs in selinux-testsuite.
>> These patches pass those tests now
>>
>> https://github.com/rhatdan/selinux-testsuite/commits/master
>>
>> Posting these patches for review and comments.
>>
>> These patches introduce 3 new security hooks.
>>
>> - security_inode_copy_up(), is called when a file is copied up. This hook
>>   prepares a new set of cred which is used for copy up operation. And
>>   new set of creds are prepared so that ->create_sid can be set appropriately
>>   and newly created file is labeled properly.
>>
>>   When a file is copied up, label of lower file is retained except for the
>>   case of context= mount where new file gets the label from context= option.
>>
>> - security_inode_copy_up_xattr(), is called when xattrs of a file are
>>   being copied up. Before this we already called security_inode_copy_up()
>>   and created new file and copied up data. That means file already got
>>   labeled properly and there is no need to take SELINUX xattr of lower
>>   file and overwrite the upper file xattr. So this hook is used to avoid
>>   copying up of SELINUX xattr.
>>
>> - dentry_create_files_as(), is called when a new file is about to be created.
>>   This hook determines what the label of the file should be if task had
>>   created that file in upper/ and sets create_sid accordingly in the passed
>>   in creds.
>>
>>   Normal transition rules don't work for the case of context mounts as
>>   underlying file system is not aware of context option which only overlay
>>   layer is aware of. For non-context mounts, creation can happen in work/
>>   dir first and then file might be renamed into upper/, and it might get
>>   label based on work/ dir. So this hooks helps avoiding all these issues.
>>
>>   When a new file is created in upper/, it gets its label based on transition
>>   rules. For the case of context mount, it gets the label from context=
>>   option.
>>
>> Any feedback is welcome.
>
> Hi Vivek,
>
> These patches look fine to me, thanks for all your hard work and to
> everyone who helped review and provide feedback.  I have tagged these
> patches for merging into the SELinux next branch after this merge
> window.

Okay, I just merged these patches into selinux#next.  With the
exception of some changes to restore the mode argument to
ovl_create_or_link() and to fix some whitespace damage the patches
were merged cleanly.

-- 
paul moore
www.paul-moore.com
