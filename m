From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: overlayfs access checks on underlying layers
Date: Tue, 11 Dec 2018 16:48:21 -0500
Message-ID: <20181211214821.GD17242@redhat.com>
References: <4c20a261-5ce1-f0a2-8d40-c6032a023216@tycho.nsa.gov>
 <20181204151549.GA21509@redhat.com>
 <20181204152248.GB21509@redhat.com>
 <CAJfpegtFVvq286HAorGLg6ywMsfs51KqaQwFkcuV7Dtu8TLaLg@mail.gmail.com>
 <20181204154243.GA16818@redhat.com>
 <665ec6f3-f16d-681f-30d5-eface14c9808@tycho.nsa.gov>
 <20181204161747.GC16818@redhat.com>
 <e8841bf0-d6b8-0e7d-6a35-055a06441d30@tycho.nsa.gov>
 <20181205134317.GA11337@redhat.com>
 <8eb7f677-fd71-c31b-bfed-29fb7187d132@tycho.nsa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8eb7f677-fd71-c31b-bfed-29fb7187d132@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Ondrej Mosnacek <omosnace@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>, Mark Salyzyn <salyzyn@android.com>, Paul Moore <paul@paul-moore.com>, linux-kernel@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org, Daniel J Walsh <dwalsh@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Dec 06, 2018 at 03:26:26PM -0500, Stephen Smalley wrote:
> On 12/5/18 8:43 AM, Vivek Goyal wrote:
> > On Tue, Dec 04, 2018 at 11:49:16AM -0500, Stephen Smalley wrote:
> > > On 12/4/18 11:17 AM, Vivek Goyal wrote:
> > > > On Tue, Dec 04, 2018 at 11:05:46AM -0500, Stephen Smalley wrote:
> > > > > On 12/4/18 10:42 AM, Vivek Goyal wrote:
> > > > > > On Tue, Dec 04, 2018 at 04:31:09PM +0100, Miklos Szeredi wrote:
> > > > > > > On Tue, Dec 4, 2018 at 4:22 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > > > > 
> > > > > > > > Having said that, this still create little anomaly when mknod to client
> > > > > > > > is not allowed on context label. So a device file, which is on lower
> > > > > > > > and client can not open it for read/write on host, it can now be opened
> > > > > > > > for read/write because mounter will allow access. So why it is different
> > > > > > > > that regular copy up. Well, in regular copy up, we created a copy of
> > > > > > > > the original object and allowed writing to that object (cp --preserve=all)
> > > > > > > > model. But in case of device file, writes will go to same original
> > > > > > > > object. (And not a separate copy).
> > > > > > > 
> > > > > > > That's true.
> > > > > > > 
> > > > > > > In that sense copy up of special file should result in upper having
> > > > > > > the same label as of lower, right?
> > > > > > 
> > > > > > I guess that might be reasonable (if this behavior is a concern). So even
> > > > > > after copy up, client will not be able to read/write a device if it was
> > > > > > not allowed on lower.
> > > > > > 
> > > > > > Stephen, what do you think about retaining label of lower for device
> > > > > > files during copy up. What about socket/fifo.
> > > > > 
> > > > > We don't check client task access to the upper inode label, only to the
> > > > > overlay, right?  So the client is still free to access the device through
> > > > > the overlay even if we preserve the lower inode label on the upper inode?
> > > > > What do we gain?
> > > > 
> > > > That's only with latest code and Miklos said he will revert it for 4.20.
> > > > 
> > > > IOW, I am assuming that we will continue to check access to a file
> > > > on upper in the context of mounter. Otherwise, client will be able to access
> > > > files on upper/ which even mounter can't access.
> > > 
> > > I was assuming we're talking about the proposed solution, where we check
> > > client access to the overlay (unchanged), mounter access to lower
> > > (unchanged), copy-up if denied (new), mounter access to upper (new in the
> > > sense that previously we didn't copy-up on denials).
> > > 
> > > In that situation, propagating the lower inode label to the upper inode only
> > > impacts the mounter checks, and in that case makes copy-up pointless - if it
> > > wasn't allowed to lower it won't be allowed to upper.  If it is allowed,
> > > then client task is free to access the device regardless as long as it has
> > > permissions to the overlay inode.  So I don't see what we gain by
> > > propagating the lower inode label to the upper inode in the context mount
> > > case, and it creates an inconsistency between special files and regular
> > > ones.
> > 
> > If we agree on retaining lower label of lower device file on copy up, then
> > I am assuming we will change rule c) to copy up only non device files.
> > (because if you don't have access on lower, you will not have access
> > even after copy up).
> > 
> > There are other paths where copy up happnes. Like link or when file
> > metadata (ownership, permissions, timestmap) changes. In those cases,
> > if we retain the lower label over copy up, it probably will help.
> > 
> > IOW, just by creating a link to a device, one will not get access to
> > a device on upper which could not be accessed on lower.
> > 
> > Device files are special anyway. In regular files we are creating a
> > copy and user writes to copy. But that's not the case with device
> > files. So I guess these will have to be treated differently.
> 
> I don't understand what you are suggesting.  In the case of a context mount,
> the context specified by the mounter must be assigned to the upper inode for
> any files that are copied up.  Otherwise, changes to file data or metadata
> made through the overlay will be visible under two different security
> contexts simultaneously: the context of the overlay inode (i.e. the one
> specified by the mounter) and the context of the upper inode (in your
> suggestion, the context from the lower inode). This allows a violation of
> MAC policy where one can leak data through an overlay to an unauthorized
> context.

Hi Stephen,

Sorry, I don't understand this point of leaking data through overlay. Even
if we retain lower label on copy up (for device file), to open that file
process should have access on overlay context label and then mounter needs
to have access on upper inode (lower label). This is not different from
opening a file on lower. Just that metadata of this file on upper might
be different.

Can you elaborate a bit more on how this is leaking data through overlay
mount. If it is, then why accessing file on lower is not equivalent of
leaking of data. 

Thanks
Vivek
