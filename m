From: Mark Salyzyn via Linux-f2fs-devel
 <linux-f2fs-devel@lists.sourceforge.net>
Subject: Re: [PATCH] Add flags option to get xattr method paired
 to __vfs_getxattr
Date: Tue, 13 Aug 2019 07:37:29 -0700
Message-ID: <e211bef2-f346-c9c7-f4b8-c774159b14e1@android.com>
References: <20190812193320.200472-1-salyzyn@android.com>
 <20190813084801.GA972@kroah.com>
Reply-To: Mark Salyzyn <salyzyn@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20190813084801.GA972@kroah.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Latchesar Ionkov <lucho@ionkov.net>, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, linux-integrity@vger.kernel.org, Martin Brandenburg <martin@omnibond.com>, samba-technical@lists.samba.org, Dominique Martinet <asmadeus@codewreck.org>, Mimi Zohar <zohar@linux.ibm.com>, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Chris Mason <clm@fb.com>, "David S. Miller" <davem@davemloft.net>, Andreas Dilger <adilger.kernel@dilger.ca>, Eric Paris <eparis@parisplace.org>, netdev@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, Mike Marshall <hubcap@omnibond.com>, linux-xfs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>, Sage Weil <sage@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Richard Weinberger <richard@nod.at>, Mark Fasheh <mark@fasheh.com>, Hugh Dickins <hughd@google.com>, James
List-Id: linux-unionfs@vger.kernel.org

On 8/13/19 1:48 AM, Greg Kroah-Hartman wrote:
> On Mon, Aug 12, 2019 at 12:32:49PM -0700, Mark Salyzyn wrote:
>> --- a/include/linux/xattr.h
>> +++ b/include/linux/xattr.h
>> @@ -30,10 +30,10 @@ struct xattr_handler {
>>   	const char *prefix;
>>   	int flags;      /* fs private flags */
>>   	bool (*list)(struct dentry *dentry);
>> -	int (*get)(const struct xattr_handler *, struct dentry *dentry,
>> +	int (*get)(const struct xattr_handler *handler, struct dentry *dentry,
>>   		   struct inode *inode, const char *name, void *buffer,
>> -		   size_t size);
>> -	int (*set)(const struct xattr_handler *, struct dentry *dentry,
>> +		   size_t size, int flags);
>> +	int (*set)(const struct xattr_handler *handler, struct dentry *dentry,
>>   		   struct inode *inode, const char *name, const void *buffer,
>>   		   size_t size, int flags);
> Wow, 7 arguments.  Isn't there some nice rule of thumb that says once
> you get more then 5, a function becomes impossible to understand?

This is a method with a pot-pourri of somewhat intuitive useful, but not 
always necessary, arguments, the additional argument does not complicate 
the function(s) AFAIK, but maybe its usage. Most functions do not even 
reference handler, the inode is typically a derivative of dentry, The 
arguments most used are the name of the attribute and the buffer/size 
the results are to be placed into.

The addition of flags is actually a pattern borrowed from the [.]set 
method, which provides at least 32 bits of 'control' (of which we added 
only one). Before, it was an anti-pattern.

> Surely this could be a structure passed in here somehow, that way when
> you add the 8th argument in the future, you don't have to change
> everything yet again?  :)
Just be happy I provided int flags, instead of bool no_security ;-> 
there are a few bits there that can be used in the future.
> I don't have anything concrete to offer as a replacement fix for this,
> but to me this just feels really wrong...

I went through 6 different alternatives (in the overlayfs security fix 
patch set) until I found this one that resonated with the security and 
filesystem stakeholders. The one was a direct result of trying to reduce 
the security attack surface. This code was created by threading a 
needle, and evolution. I am game for a 7th alternative to solve the 
unionfs set of recursive calls into acquiring the extended attributes.

-- Mark
