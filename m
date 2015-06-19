From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 0/8] Security: Provide unioned file support
Date: Fri, 19 Jun 2015 10:36:03 +0200
Message-ID: <CAJfpeguSPJduSF4wuTHZUbvnxOeNFnT40WQXM_+i6S8mHzvWLQ@mail.gmail.com>
References: <20150618133215.12722.70352.stgit@warthog.procyon.org.uk>
	<20150619072015.GH17109@ZenIV.linux.org.uk>
	<CAJfpeguZq-1C_hnCcyrW3MCcpP4Bwe+L4gpWaOeJCqa1q8j4Hg@mail.gmail.com>
	<20150619075903.GI17109@ZenIV.linux.org.uk>
	<20150619081128.GA24181@tucsk>
	<20150619082928.GJ17109@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150619082928.GJ17109@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, sds@tycho.nsa.gov, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, linux-security-module@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Jun 19, 2015 at 10:29 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> Directory, probably?
>
>> -     dentry = lookup_one_len(name, parent->dentry, namelen);
>> +     dentry = lookup_one_len(name, parent, namelen);
>
> ... it would better be one.

My point is: without a bloody accessor, there's no way to warn if the
use is illegal (i.e. nondirectory).

Maybe we won't need file->f_dentry, but we do need a way to WARN about
abuse (which there IS probably a significant number already and
nothing preventing more).

Thanks,
Miklos
