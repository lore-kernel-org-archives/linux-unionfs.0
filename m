From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 03/17] ovl: decode pure upper file handles
Date: Fri, 19 Jan 2018 22:10:11 +0200
Message-ID: <CAOQ4uxjKvusKuQP9ACWGQPr3XeT3KskOvj8fQ+L5aEHUB-8n1A@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
 <1515086449-26563-4-git-send-email-amir73il@gmail.com> <CAJfpegt=4Mk7B7E9c7CGJHdWZsVFQAqfJ_NbRNQNOpSZFYudrg@mail.gmail.com>
 <CAOQ4uxg34b6TZ6hwPczv_m_HquR6apnPy0gexHezixMedVqUZA@mail.gmail.com>
 <CAJfpegttoV7aPN2sS6RXONh0eFQ9xyoFxZbzVG7UMCcAJ+zjtg@mail.gmail.com>
 <CAOQ4uxhaC3b2N1rNCBgv0MTyBQgWFZKyVV60VWnudb_wY6A98Q@mail.gmail.com>
 <CAJfpeguVZztckNqML_hJRrEXumMMAeB6+Ha2djPrmCbqXz1brw@mail.gmail.com>
 <CAOQ4uxh0EEuhsLxD3M_xngMd14C=hGb8U12yPe=duELwb4yNDQ@mail.gmail.com>
 <CAOQ4uxhHUaorYA5ZAXQrfaOrp6Xa4cabz+ZFRdVBp6Mf-ebb0g@mail.gmail.com>
 <CAOQ4uxhO+oOGWfSnafNO84GYT0_ihNtR_ekna+DH7rzWMZTgwg@mail.gmail.com>
 <20180119103952.GA24104@veci.piliscsaba.redhat.com> <CAOQ4uxgdww=-R24R4quD4iV0oJ9Wj5WC_-tkvOF_kZgHKa3P5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxgdww=-R24R4quD4iV0oJ9Wj5WC_-tkvOF_kZgHKa3P5w@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Jan 19, 2018 at 1:07 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Jan 19, 2018 at 12:39 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Fri, Jan 19, 2018 at 02:23:35AM +0200, Amir Goldstein wrote:
>>> > How is this for an option?
>> [...]
>>> > +struct dentry *d_obtain_alias_fsdata(struct inode *inode, void **fsdata)
>>> > +{
>>> > +       return __d_obtain_alias(inode, 1, fsdata);
>>> >  }
>>> >  EXPORT_SYMBOL(d_obtain_alias);
>>
>> It would work, but I like this interface better:
>>
>> +extern struct dentry * d_alloc_anon(struct super_block *);
>> +extern struct dentry * d_instantiate_anon(struct dentry *, struct inode *);
>>
>
> OK. Thanks for the patch!
>

Added your dcache patch to the series and reworked my patches
to use the new helpers.

Tested result is pushed to:
https://github.com/amir73il/linux/commits/ovl-nfs-export-v3

Prep patches changes since v2:
- Rebased over fix patch "hash all directory inodes for fsnotify"
- Rename mount/config option from "verify" to "nfs_export"
- Force r/o mount when index dir creation fails
- Allow enabling "nfs_export" for non-upper mount
- Require "redirect_dir=nofollow" for non-upper mount
- Rename dir index entries xattr from ".origin" to ".upper"
- Re-factor ovl_{get|set|verify}_origin() helpers
- Simplify test for temp index name (starts with #)
- Abandon ovl_dentry_is_renamed() test for lower st_ino
- Document overhead on mount with full index
- Document change of behavior when verifying lower origin
- Added patch to make room in ovl_entry struct

NFS export changes since v2:
- Fix exportfs ops for r/o overlay with no upperdir
- Document reason for copy up directory on encode
- Take care of racing with rename while connecting dir
- Explain the reasons for choosing the 'connected' dir approach
- Do not add dentry without ovl_entry to dcache

Optimizations TODO:
- Copy up on encode only when lower ancestor is below middle layer redirect
- Hash inode by fh to avoid origin decode of whiteout fh

As far as I know, the series is now functionally correct and all comments
so far addressed. The remaining optimizations will be done on top of this
series.

Thanks,
Amir.
