From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/8] Security: Provide unioned file support
Date: Fri, 19 Jun 2015 15:04:04 +0100
Message-ID: <13612.1434722644@warthog.procyon.org.uk>
References: <CAJfpeguZq-1C_hnCcyrW3MCcpP4Bwe+L4gpWaOeJCqa1q8j4Hg@mail.gmail.com> <20150618133215.12722.70352.stgit@warthog.procyon.org.uk> <20150619072015.GH17109@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpeguZq-1C_hnCcyrW3MCcpP4Bwe+L4gpWaOeJCqa1q8j4Hg@mail.gmail.com>
Content-ID: <13611.1434722644.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, sds@tycho.nsa.gov, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, linux-security-module@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> What's going to happen to all those f_path.dentry uses where the
> filesystem thinks it's getting its own dentry?

Hmmm...  I guess that breaks CIFS.

David
