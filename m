From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2/7] Overlayfs: Use copy-up security hooks
Date: Fri, 07 Nov 2014 22:05:40 +0000
Message-ID: <3148.1415397940@warthog.procyon.org.uk>
References: <4109261.WfcAOoSvNG@sifl> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154238.2555.85960.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <4109261.WfcAOoSvNG@sifl>
Content-ID: <3147.1415397940.1@warthog.procyon.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Paul Moore <paul@paul-moore.com> wrote:

> So the LSM must modify the xattr in place?  I suppose that since the @value
> is allocated to the max size it shouldn't be a problem.  Just checking ...

... And the caller must provide a maximally sized buffer (which it likely has
to allocate anyway).

I'm not sure I really need to provide the modification thing.  I suspect a
binary keep or discard decision is sufficient.

David
