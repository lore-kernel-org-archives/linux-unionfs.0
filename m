From: Mark Salyzyn via Linux-f2fs-devel
 <linux-f2fs-devel@lists.sourceforge.net>
Subject: Re: [PATCH v2] Add flags option to get xattr method
 paired to __vfs_getxattr
Date: Wed, 14 Aug 2019 07:54:16 -0700
Message-ID: <71d66fd1-cc94-fd0c-dfa7-115ba8a6b95a@android.com>
References: <20190813145527.26289-1-salyzyn@android.com>
 <20190814110022.GB26273@quack2.suse.cz>
Reply-To: Mark Salyzyn <salyzyn@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20190814110022.GB26273@quack2.suse.cz>
Content-Language: en-GB
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Jan Kara <jack@suse.cz>
Cc: Latchesar Ionkov <lucho@ionkov.net>, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Phillip Lougher <phillip@squashfs.org.uk>, linux-integrity@vger.kernel.org, Martin Brandenburg <martin@omnibond.com>, samba-technical@lists.samba.org, Dominique Martinet <asmadeus@codewreck.org>, Mimi Zohar <zohar@linux.ibm.com>, Adrian Hunter <adrian.hunter@intel.com>, linux-mm@kvack.org, Chris Mason <clm@fb.com>, netdev@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, linux-xfs@vger.kernel.org, Eric Paris <eparis@parisplace.org>, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, Stephen Smalley <sds@tycho.nsa.gov>, Mike Marshall <hubcap@omnibond.com>, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, Paul Moore <paul@paul-moore.com>, Sage Weil <sage@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Richard
List-Id: linux-unionfs@vger.kernel.org

On 8/14/19 4:00 AM, Jan Kara wrote:
> On Tue 13-08-19 07:55:06, Mark Salyzyn wrote:
> ...
>> diff --git a/fs/xattr.c b/fs/xattr.c
>> index 90dd78f0eb27..71f887518d6f 100644
>> --- a/fs/xattr.c
>> +++ b/fs/xattr.c
> ...
>>   ssize_t
>>   __vfs_getxattr(struct dentry *dentry, struct inode *inode, const char *name,
>> -	       void *value, size_t size)
>> +	       void *value, size_t size, int flags)
>>   {
>>   	const struct xattr_handler *handler;
>> -
>> -	handler = xattr_resolve_name(inode, &name);
>> -	if (IS_ERR(handler))
>> -		return PTR_ERR(handler);
>> -	if (!handler->get)
>> -		return -EOPNOTSUPP;
>> -	return handler->get(handler, dentry, inode, name, value, size);
>> -}
>> -EXPORT_SYMBOL(__vfs_getxattr);
>> -
>> -ssize_t
>> -vfs_getxattr(struct dentry *dentry, const char *name, void *value, size_t size)
>> -{
>> -	struct inode *inode = dentry->d_inode;
>>   	int error;
>>   
>> +	if (flags & XATTR_NOSECURITY)
>> +		goto nolsm;
> Hum, is it OK for XATTR_NOSECURITY to skip even the xattr_permission()
> check? I understand that for reads of security xattrs it actually does not
> matter in practice but conceptually that seems wrong to me as
> XATTR_NOSECURITY is supposed to skip just security-module checks to avoid
> recursion AFAIU.

Good catch I think.

I was attempting to make this change purely inert, no change in 
functionality, only a change in API. Adding a call to xattr_permission 
would incur a change in overall functionality, as it would introduce 
into the current and original __vfs_getxattr a call to xattr_permission 
that was not there before.

(I will have to defer the real answer and requirements to the security 
folks)

AFAIK you are correct, and to make the call would reduce the attack 
surface, trading a very small amount of CPU utilization, for a much 
larger amount of trust.

Given the long history of this patch set (for overlayfs) and the large 
amount of stakeholders, I would _prefer_ to submit a followup 
independent functionality/security change to _vfs_get_xattr _after_ this 
makes it in.

>
>> diff --git a/include/uapi/linux/xattr.h b/include/uapi/linux/xattr.h
>> index c1395b5bd432..1216d777d210 100644
>> --- a/include/uapi/linux/xattr.h
>> +++ b/include/uapi/linux/xattr.h
>> @@ -17,8 +17,9 @@
>>   #if __UAPI_DEF_XATTR
>>   #define __USE_KERNEL_XATTR_DEFS
>>   
>> -#define XATTR_CREATE	0x1	/* set value, fail if attr already exists */
>> -#define XATTR_REPLACE	0x2	/* set value, fail if attr does not exist */
>> +#define XATTR_CREATE	 0x1	/* set value, fail if attr already exists */
>> +#define XATTR_REPLACE	 0x2	/* set value, fail if attr does not exist */
>> +#define XATTR_NOSECURITY 0x4	/* get value, do not involve security check */
>>   #endif
> It seems confusing to export XATTR_NOSECURITY definition to userspace when
> that is kernel-internal flag. I'd just define it in include/linux/xattr.h
> somewhere from the top of flags space (like 0x40000000).
>
> Otherwise the patch looks OK to me (cannot really comment on the security
> module aspect of this whole thing though).

Good point. However, we do need to keep these flags together to reduce 
maintenance risk, I personally abhor two locations for flags bits even 
if one comes from the opposite bit-side; collisions are undetectable at 
build time. Although I have not gone through the entire thought 
experiment, I am expecting that fuse could possibly benefit from this 
flag (if exposed) since it also has a security recursion. That said, 
fuse is probably the example of a gaping wide attack surface if user 
space had access to it ... your xattr_permissions call addition 
requested above would be realistically, not just pedantically, required!

I have to respin the patch because of yet another hole in filesystem 
coverage (I blew the mechanical ubifs adjustment, adjusted the wrong 
function), so please do tell if my rationalizations above hit a note, or 
if I _need_ to make the changes in this patch (change it to a series?).

Thanks -- Mark Salyzyn
