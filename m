From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/7] Security: Provide copy-up security hooks for unioned files
Date: Fri, 07 Nov 2014 22:10:34 +0000
Message-ID: <3206.1415398234@warthog.procyon.org.uk>
References: <2455443.WUExuKDC0I@sifl> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154228.2555.55814.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <2455443.WUExuKDC0I@sifl>
Content-ID: <3205.1415398234.1@warthog.procyon.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Paul Moore <paul@paul-moore.com> wrote:

> This didn't occur to me earlier, but we may want to pick a different phrase
> to use instead of "copy_up" as that has a special meaning for some
> security/MLS folks...

It does?

security_inode_make_union()?

David


