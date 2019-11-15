Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20191114154723.GJ26530@ZenIV.linux.org.uk> <20191114195544.GB5569@miu.piliscsaba.redhat.com>
 <CAOQ4uxhjAwU_V0cUF+VkQbAwXKTJKsZuyysNXMecuM9Y1iuUsw@mail.gmail.com>
 <CAOQ4uxhaw_H0ScTvehHqZVkp5KgBtd_bgcf-0bo_GnUrT8Rwqg@mail.gmail.com> <20191114234905.GL26530@ZenIV.linux.org.uk>
In-Reply-To: <20191114234905.GL26530@ZenIV.linux.org.uk>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 15 Nov 2019 08:07:08 +0200
Message-ID: <CAOQ4uxi1DCG5voZDXSxvsxMcyHDDc6YsqG=o7x1m6eVM8foTTQ@mail.gmail.com>
Subject: Re: [RFC] is ovl_fh->fid really intended to be misaligned?
Content-Type: text/plain; charset="UTF-8"
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Nov 15, 2019 at 1:49 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Fri, Nov 15, 2019 at 01:13:15AM +0200, Amir Goldstein wrote:
>
> > See attached.
> > IMHO it looks much easier to verify that these changes are correct
> > compared to your open coded offset shifting all over the place.
> >
> > It even passed the exportfs tests first try.
> > Only some index tests are failing.
> >
> > If you like this version, I can fix up the failures and add Al's
> > suggestions to simplify code with OVL_FH_MAX_SIZE
> > memory allocations.
>
> Huh?  Correct me if I'm wrong, but doesn't that patch make it
> reject all old fhandles just on the type check?  That includes
> anything sent over the wire, or stored in xattrs, or represented
> as names in indexdir...

That's not what the patch does.
It does reject OVL_FILEID_V0 in ovl_fh_to_dentry(), but
that can easily be fixed to convert them on-the-fly.
I just left this part out.

The patch does not change on-disk format, not in xattr
and not in index names - or not intentionally anyway, see:

ovl_get_fh():
...
// reading xattr into aligned buffer at offset 3
        res = vfs_getxattr(dentry, name, fh->buf, res);
        if (res < 0)
                goto fail;
...
// checking old v0 on-disk format
        err = ovl_check_fb_len(&fh->fb, res);
...

ovl_verify_set_fh():
...
// encode correctly aligned buffer
        fh = ovl_encode_real_fh(real, is_upper);
...
// store old format into xattr
                err = ovl_do_setxattr(dentry, name, fh->buf, fh->fb.len, 0);

Similarly in ovl_get_index_name_fh():
// here was a bug
        n = kcalloc(fh->fb.len + OVL_FH_WIRE_OFFSET, 2, GFP_KERNEL);
...
// hex encode the old format
        s  = bin2hex(n, fh->buf, fh->fb.len);

>
> _If_ we can change the fhandle layout at will, everything's
> easy - you can add padding in any way you like.  But fhandles
> are a lot more permanent than this approach would require -
> mere rebooting the server into a new kernel must not make the
> clients see -ESTALE on everything they'd imported from it!
> And then there's implied "you can throw indexdir contents at
> any time", which is also not a good thing to do.
>

I think I understand the confusion.
There is no requirement that the file handles stored on-disk
will be the same format as those exported on wire.
The file handles coming from wire are rarely compared
with those on-disk and vice versa. IIRC, there is a single
place that uses an fh from wire to lookup on-disk:

ovl_lower_fh_to_d():
...
         /* Then lookup indexed upper/whiteout by origin fh */
        if (ofs->indexdir) {
                index = ovl_get_index_fh(ofs, fh);

But that is the exception.
Most of the time, the on-disk fh are used to make sure that
union inode numbers are persistently unique across the overlay.

> Sure, introducing a variant with better layout would be nice,
> and using a new type for it is pretty much required, but
> you can't just discard old-layout fhandles you'd ever issued.
>

In truth, we have ample evidence that ovl nfs export is not
widely in use. We know that docker and such have disabled
index because it exposed mount leak bugs that they have.
And we got too few nfs export bug reports (single reporter
IIRC).
But still, as I said, it is quite easy to respect OVL_FILEID_V0
file handles that were handed out to nfs clients after upgrade.

Unless I am still missing something...

Thanks,
Amir.
