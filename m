From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v14 2/5] overlayfs: check CAP_DAC_READ_SEARCH before
 issuing exportfs_decode_fh
Date: Sun, 27 Oct 2019 09:24:52 +0200
Message-ID: <CAOQ4uxh_K=p7z+qbkjSf_+hhVsw9xBuNc61dYnpkHFVUfxJaCw@mail.gmail.com>
References: <20191022204453.97058-1-salyzyn@android.com> <20191022204453.97058-3-salyzyn@android.com>
 <CAJfpegsCzwXF5fD1oA+XMrPQ7u8URsXRGOOHkB=ON7fLnd_gFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegsCzwXF5fD1oA+XMrPQ7u8URsXRGOOHkB=ON7fLnd_gFQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Mark Salyzyn <salyzyn@android.com>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-team@android.com, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>
List-Id: linux-unionfs@vger.kernel.org

+ ebiederm and nfsd folks

On Wed, Oct 23, 2019 at 11:08 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>
>
> On Tue, Oct 22, 2019 at 10:46 PM Mark Salyzyn <salyzyn@android.com> wrote:
> >
> > Assumption never checked, should fail if the mounter creds are not
> > sufficient.
>
> A bit more explanation would be nice.  Like a pointer to the explanation given in the open_by_handle_at(2) code where this check was presumably taken from.
>

Well, it's not that simple (TM).
If you are considering unprivileged overlay mounts, then this should be
ns_capable() check, even though open_by_handle_at(2) does not
currently allow userspace nfsd to decode file handles.

Unlike open_by_handle_at(2), overlayfs (currently) never exposes file
data via decoded origin fh. AFAIK, it only exposes the origin st_ino
st_dev and some nlink related accounting.

I have been trying to understand from code if nfsd exports are allowed
from non privileged containers and couldn't figure it out (?).
If non privileged container is allowed to export nosubtreecheck export
then non privileged container root can already decode file handles...

Thanks,
Amir.
