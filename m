From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [RFC PATCH 1/2] security, capabilities: create CAP_TRUSTED
Date: Sat, 21 Oct 2017 11:03:02 -0500
Message-ID: <20171021160302.GA2842@mail.hallyn.com>
References: <20171021134558.21195-1-nicolas@belouin.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171021134558.21195-1-nicolas@belouin.fr>
Sender: owner-linux-security-module@vger.kernel.org
To: Nicolas Belouin <nicolas@belouin.fr>
Cc: Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, David Woodhouse <dwmw2@infradead.org>, Dave Kleikamp <shaggy@kernel.org>, Mark Fasheh <mfasheh@versity.com>, Joel Becker <jlbec@evilplan.org>, Miklos Szeredi <miklos@szeredi.hu>, Phillip Lougher <phillip@squashfs.org.uk>, Richard Weinberger <richard@nod.at>, Artem Bityutskiy <dedekind1@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge@hallyn.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, James Morris <james.l.morris@oracle.com>, linux-ext4@vger.kernel.o
List-Id: linux-unionfs@vger.kernel.org

Quoting Nicolas Belouin (nicolas@belouin.fr):
> with CAP_SYS_ADMIN being bloated, the usefulness of using it to
> flag a process to be entrusted for e.g reading and writing trusted
> xattr is near zero.
> CAP_TRUSTED aims to provide userland with a way to mark a process as
> entrusted to do specific (not specially admin-centered) actions. It
> would for example allow a process to red/write the trusted xattrs.

You say "for example".  Are you intending to add more uses?  If so, what
are they?  If not, how about renaming it CAP_TRUSTED_XATTR?

What all does allowing writes to trusted xattrs give you?  There are
the overlayfs whiteouts, what else?
