From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH v14 2/5] overlayfs: check CAP_DAC_READ_SEARCH before
 issuing exportfs_decode_fh
Date: Mon, 28 Oct 2019 12:27:17 -0400
Message-ID: <20191028162717.GB5339@fieldses.org>
References: <20191022204453.97058-1-salyzyn@android.com>
 <20191022204453.97058-3-salyzyn@android.com>
 <CAJfpegsCzwXF5fD1oA+XMrPQ7u8URsXRGOOHkB=ON7fLnd_gFQ@mail.gmail.com>
 <CAOQ4uxh_K=p7z+qbkjSf_+hhVsw9xBuNc61dYnpkHFVUfxJaCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh_K=p7z+qbkjSf_+hhVsw9xBuNc61dYnpkHFVUfxJaCw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Mark Salyzyn <salyzyn@android.com>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-team@android.com, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Jeff Layton <jlayton@kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Sun, Oct 27, 2019 at 09:24:52AM +0200, Amir Goldstein wrote:
> Well, it's not that simple (TM).
> If you are considering unprivileged overlay mounts, then this should be
> ns_capable() check, even though open_by_handle_at(2) does not
> currently allow userspace nfsd to decode file handles.
> 
> Unlike open_by_handle_at(2), overlayfs (currently) never exposes file
> data via decoded origin fh. AFAIK, it only exposes the origin st_ino
> st_dev and some nlink related accounting.
> 
> I have been trying to understand from code if nfsd exports are allowed
> from non privileged containers and couldn't figure it out (?).
> If non privileged container is allowed to export nosubtreecheck export
> then non privileged container root can already decode file handles...

I don't see any special checks in nfsctl_transaction_write() or
write_threads().  I guess it's just depending on the (0600) file
permissions.  I'm vague on how file permissions work in containers.

The issue with filehandles is that they allow you to bypass directory
lookup permissions.  Keeping a file private by denying permission to
look it up doesn't sound like a good idea to me, honestly, but it does
work on local posix filesystems, so we don't want to break that.

Filehandles are generally pretty easy to guess, and can't be revoked, so
we're more worried about using them (with open_by_handle_at()) than
reading them (with name_to_handle_at()), but we try to prevent the
latter as well.

--b.
