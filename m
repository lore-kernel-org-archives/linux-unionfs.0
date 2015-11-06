From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: kernel BUG when fsync'ing file in a overlayfs merged dir, located
 on btrfs
Date: Fri, 6 Nov 2015 09:46:14 -0500
Message-ID: <563CBD36.3080105@suse.com>
References: <1443643065-16460-1-git-send-email-lebedev.ri@gmail.com>
 <563C171F.30702@jeffm.io> <20151106031845.GV22011@ZenIV.linux.org.uk>
 <563C26AE.1020403@jeffm.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <563C26AE.1020403@jeffm.io>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Mahoney <jeffm@jeffm.io>, Al Viro <viro@ZenIV.linux.org.uk>
Cc: Roman Lebedev <lebedev.ri@gmail.com>, David Howells <dhowells@redhat.com>, linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
List-Id: linux-unionfs@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/5/15 11:03 PM, Jeff Mahoney wrote:
> On 11/5/15 10:18 PM, Al Viro wrote:
>> On Thu, Nov 05, 2015 at 09:57:35PM -0500, Jeff Mahoney wrote:
>> 
>>> So now file_operations callbacks can't assume that
>>> file->f_path.dentry belongs to the same file system that
>>> implements the callback.  More than that, any code that could
>>> ultimately get a dentry that comes from an open file can't
>>> trust that it's from the same file system.
>> 
>> Use file_inode() for inode.
>> 
>>> This crash is due to this issue.  Unlike xfs and ext2/3/4, we
>>> use file->f_path.dentry->d_inode to resolve the inode.  Using
>>> file_inode() is an easy enough fix here, but we run into
>>> trouble later.  We have logic in the btrfs fsync() call path
>>> (check_parent_dirs_for_sync) that walks back up the dentry
>>> chain examining the inode's last transaction and last unlink
>>> transaction to determine whether a full transaction commit is
>>> required.  This obviously doesn't work if we're walking the 
>>> overlayfs path instead.  Regardless of any argument over
>>> whether that's doing the right thing, it's a pretty common
>>> pattern to assume that file->f_path.dentry comes from the same
>>> file system when using a file_operation.  Is it intended that
>>> that assumption is no longer valid?
>> 
>> It's actually rare, and your example is a perfect demonstration
>> of the reasons why it is so rare.  What's to protect
>> btrfs_log_dentry_safe() from racing with rename(2)?  Sure, you do
>> dget_parent().  Which protects you from having one-time parent
>> dentry freed under you.  What it doesn't do is making any
>> promises about its relationship with your file.
> 
> I suppose the irony here is that, AFAIK, that code is to ensure a
> file doesn't get lost between transactions due to rename.
> 
> Isn't the file->f_path.dentry relationship stable otherwise,
> though? The name might change and the parent might change but the
> dentry that the file points to won't.

And, taking it a bit further, it's impossible for a rename to end up
with a file pointing into a different file system.  So this btrfs case
might misbehave, but it would never crash like we're seeing here.

- -Jeff


> I did find a few other places where that assumption happens without
> any questionable traversals.  Sure, all three are in file systems
> unlikely to be used with overlayfs.
> 
> ocfs2_prepare_inode_for_write uses file->f_path.dentry for 
> should_remove_suid (due to needing to do it early since cluster
> locking is unknown in setattr, according to the commit).  Having 
> should_remove_suid operate on an inode would solve that easily.
> 
> fat_ioctl_set_attributes uses it to call fat_setattr, but that only
> uses the inode and could have the inode_operation use a wrapper.
> 
> cifs_new_fileinfo keeps a reference to the dentry but it seems to
> be used mostly to access the inode except for the nasty-looking
> call to build_path_from_dentry in cifs_reopen_file, which I won't
> be touching. That does look like a questionable traversal,
> especially with the "we can't take the rename lock here" comment.
> 
> -Jeff
> 


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJWPL01AAoJEB57S2MheeWy1+IP/RfWvnpaXOCA2HJhzyR0attX
D+SYah7Dc5OBicN0lghIg5ka0U2J1+l051yOOkT2sDRE23Lyu9/wmxhQVerx7hN4
js/ZGwbmGfO9I3kXbAKzGdsAscVAgvTcEp8gYXWFCzYIRYyDKEJM8xrQMM+Z2mIy
AMu6lzMRFGD7q2KIITZzML0cozgT0TREE9D9+IrT3ywxAegIPATxwFp3pDRDwl4F
zb2QjJjJvw/z0LEAlatwV1H7AAIZxAVrMWVywlsrdvg+pwA508JvkN7Wk06dAcJ2
YB+ddVIQsYyJuBYMA+IQsCM9q7LjIVPskoqi8BMxS2MvYObu6Z0zU+Iwcp0RnVa+
FiKt3gfRR0yOAuulzg9wKylYasIC8kfKD1POaAmOBgLErhDFtXIsJSXuw5HgY/VR
LsSAbyOMfWg+YvreswQ7d7VMnK0wIJuRnludWVbQIn8y+4RKbqj2jiYIlZ7FMeUu
rSSPlNt0GKISaSM3iSBrR2qN8PLvVyxdXpZSCl5itfqNea6KAwL+Kj61x0rNZhhF
GkQlwsxJxYEue1eqqZU8iEkd0y93yPo3puhH7yHtT+dJW0NahjKiJF6TAGHF3C4a
dEatwl6FSvDJA1aXvHG2dMfbtIiywKM1LJ4VAP1TOsbL3sqG3i4Orh7cN4bl2tYv
/D9wgUU17XXdK76ysaxM
=iP2W
-----END PGP SIGNATURE-----
