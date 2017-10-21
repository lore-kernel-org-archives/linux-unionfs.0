From: nicolas@belouin.fr
Subject: Re: [RFC PATCH 1/2] security, capabilities: create CAP_TRUSTED
Date: Sat, 21 Oct 2017 21:09:32 +0200
Message-ID: <201710211909.v9LJ9Zg8033866__40171.4235581041$1508613150$gmane$org@smtp6.infomaniak.ch>
References: <20171021134558.21195-1-nicolas@belouin.fr> <20171021160302.GA2842@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from smtp-sh.infomaniak.ch ([128.65.195.4]:44144 "EHLO
        smtp-sh.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932159AbdJUTM2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 21 Oct 2017 15:12:28 -0400
In-Reply-To: <20171021160302.GA2842@mail.hallyn.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
Cc: Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, David Woodhouse <dwmw2@infradead.org>, Dave Kleikamp <shaggy@kernel.org>, Mark Fasheh <mfasheh@versity.com>, Joel Becker <jlbec@evilplan.org>, Miklos Szeredi <miklos@szeredi.hu>, Phillip Lougher <phillip@squashfs.org.uk>, Richard Weinberger <richard@nod.at>, Artem Bityutskiy <dedekind1@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge@hallyn.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, James.Morris@smtp6.infomaniak.ch

<james.l.morris@oracle.com>,linux-ext4@vger.kernel.org,linux-kernel@vger.kernel.org,linux-f2fs-devel@lists.sourceforge.net,linux-fsdevel@vger.kernel.org,linux-mtd@lists.infradead.org,jfs-discussion@lists.sourceforge.net,ocfs2-devel@oss.oracle.com,linux-unionfs@vger.kernel.org,reiserfs-devel@vger.kernel.org,linux-security-module@vger.kernel.org,selinux@tycho.nsa.gov,linux-api@vger.kernel.org,kernel-hardening@lists.openwall.com
From: Nicolas Belouin <nicolas@belouin.fr>
Message-ID: <99179B10-4EAE-4FAB-9D14-B885156261B3@belouin.fr>



On October 21, 2017 6:03:02 PM GMT+02:00, "Serge E. Hallyn" <serge@hallyn.com> wrote:
>Quoting Nicolas Belouin (nicolas@belouin.fr):
>> with CAP_SYS_ADMIN being bloated, the usefulness of using it to
>> flag a process to be entrusted for e.g reading and writing trusted
>> xattr is near zero.
>> CAP_TRUSTED aims to provide userland with a way to mark a process as
>> entrusted to do specific (not specially admin-centered) actions. It
>> would for example allow a process to red/write the trusted xattrs.
>
>You say "for example".  Are you intending to add more uses?  If so,
>what
>are they?  If not, how about renaming it CAP_TRUSTED_XATTR?
>

I don't see any other use for now, but I don't want it to be too narrow and non usable in a similar context in the future. So I believe the underlying purpose of marking a process as "trusted" (even if for now it only means rw permission on trusted xattr) is more meaningful.

>What all does allowing writes to trusted xattrs give you?  There are
>the overlayfs whiteouts, what else?

Nicolas
