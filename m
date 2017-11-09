From: "J . Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 00/14] Overlayfs NFS export support
Date: Thu, 9 Nov 2017 16:55:50 -0500
Message-ID: <20171109215550.GN8773@fieldses.org>
References: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
 <20171109190252.GL8773@fieldses.org>
 <CAOQ4uxiCx=nsSQ=XDVSOypMk9avkDn3P2YDaCoPXwFs20Qo8_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiCx=nsSQ=XDVSOypMk9avkDn3P2YDaCoPXwFs20Qo8_g@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jeff Layton <jlayton@poochiereds.net>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Nov 09, 2017 at 09:59:10PM +0200, Amir Goldstein wrote:
> On Thu, Nov 9, 2017 at 9:02 PM, J . Bruce Fields <bfields@fieldses.org> wrote:
> > On Tue, Oct 17, 2017 at 07:44:17PM +0300, Amir Goldstein wrote:
> >> Miklos,
> >>
> >> This series implements NFS export support [3] and is based on
> >> two prep patch sets [1][2] posted earlier to overlayfs list.
> >> NFS export is enabled for overlayfs mount with the 'verify_dir'
> >> and 'index=all' mount options.
> >>
> >> The current implementation will copy up and index directories when
> >> directory file handles are encoded. Those extra copy ups could be
> >> avoided in the future.
> >>
> >> The current implementation does NOT support encoding connectable
> >> non-dir file handles for all overlay path types, so overlayfs should
> >> not be exported with the 'subtree_check' option.
> >> I hope this is not a show stopper for merging NFS export support?
> >
> > I'm not a big fan of subtree_check, and I'd be OK with filesystems
> > opting out of support for it.
> >
> > I'm not sure what to expect when you actually try to export overlayfs
> > with subtree_check.  Does it fail on the export, or when clients first
> > try to access it, and what kind of error do you get?
> 
> Not an issue anymore.
> I replied one day after this email that:
> 
> FYI, I implemented encoding of type OVL_FILEID_WITH_PARENT and
> pushed 2 more patches to branch ovl-nfs-export-v1, so now export with
> 'subtree_check' should work fine.

Oops, sorry, OK.

--b.
