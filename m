From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v3 2/5] overlay: test encode/decode overlay file handles
Date: Tue, 30 Jan 2018 12:54:14 +0800
Message-ID: <20180130045414.GA18267@eguan.usersys.redhat.com>
References: <1517131356-8048-1-git-send-email-amir73il@gmail.com>
 <1517131356-8048-3-git-send-email-amir73il@gmail.com>
 <20180129143940.GW18267@eguan.usersys.redhat.com>
 <CAOQ4uxiRg9ZddvnzW-X8VMqpGOWva42qZmmBzdXUqoy-n34NRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiRg9ZddvnzW-X8VMqpGOWva42qZmmBzdXUqoy-n34NRg@mail.gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Jan 29, 2018 at 07:23:49PM +0200, Amir Goldstein wrote:
> On Mon, Jan 29, 2018 at 4:39 PM, Eryu Guan <eguan@redhat.com> wrote:
> > On Sun, Jan 28, 2018 at 11:22:33AM +0200, Amir Goldstein wrote:
> >> - Check encode/write/decode/read content of lower/upper file handles
> >> - Check encode/decode/write/read content of lower/upper file handles
> >> - Check decode/read of unlinked lower/upper files and directories
> >> - Check decode/read of lower file handles after copy up, link and unlink
> >>
> >> This test requires and enables overlayfs NFS export support.
> >> NFS export support depends on and enables overlayfs index feature.
> >>
> >> This test covers only encode/decode of file handles for overlayfs
> >> configuration of all layers on the same base fs.
> >>
> >> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >
> > Looks good to me overall, just two minor issues in comments.
> >
> 
> OK. I fixed those comment in both test variants.
> Let me know if there is anything else, otherwise, I'll re-post
> with fixed to comment on patch 1.

Everything else looks fine to me. Sorry, I should have sent out an
explicit ack..

Thanks,
Eryu
