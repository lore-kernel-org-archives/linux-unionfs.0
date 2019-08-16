From: Mark Salyzyn <salyzyn@android.com>
Subject: Re: [PATCH] Add flags option to get xattr method
 paired to __vfs_getxattr
Date: Fri, 16 Aug 2019 08:30:30 -0700
Message-ID: <92b1df4b-6433-7d01-9c08-23de10e8d527@android.com>
References: <20190812193320.200472-1-salyzyn@android.com>
	<20190813084801.GA972@kroah.com>
	<alpine.LRH.2.21.1908160515130.12729@namei.org>
	<69889dec-5440-1472-ed57-380f45547581@android.com>
	<alpine.LRH.2.21.1908160825310.22623@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.21.1908160825310.22623@namei.org>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
To: James Morris <jmorris@namei.org>
Cc: Latchesar Ionkov <lucho@ionkov.net>, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, kernel-team@android.com, Martin Brandenburg <martin@omnibond.com>, samba-technical@lists.samba.org, Dominique Martinet <asmadeus@codewreck.org>, Chao Yu <yuchao0@huawei.com>, Mimi Zohar <zohar@linux.ibm.com>, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Chris Mason <clm@fb.com>, "David S. Miller" <davem@davemloft.net>, Andreas Dilger <adilger.kernel@dilger.ca>, Eric Paris <eparis@parisplace.org>, netdev@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, Mike Marshall <hubcap@omnibond.com>, linux-xfs@vger.kernel.org, Sage Weil <sage@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Richard Weinberger <richard@nod.at>, Mark Fasheh <mark@fasheh.com>, Hugh Dickins <hughd@google.com>, =?UTF-8?Q?Ernesto_A=2e_
List-Id: linux-unionfs@vger.kernel.org

On 8/15/19 3:27 PM, James Morris wrote:
> On Thu, 15 Aug 2019, Mark Salyzyn wrote:
>
>> Good Idea, but using the same argument structure for set and get I would be
>> concerned about the loss of compiler protection for the buffer argument;
> Agreed, I missed that.

Sadly, the pattern of

struct getxattr_args args;

memset(&args, 0, sizeof(args));

args.xxxx = ...

__vfs_getxattr(&args};

...

__vfs_setxattr(&args);

would be nice, so maybe we need to cool our jets and instead:

struct xattr_gs_args {
	struct dentry *dentry;
	struct inode *inode;
	const char *name;
	union {
	        void *buffer;
	        const void *value;
	};
	size_t size;
	int flags;
};

value _must_ be referenced for all setxattr operations, buffer for getxattr operations (how can we enforce that?).

>> struct getxattr_args {
>> 	struct dentry *dentry;
>> 	struct inode *inode;
>> 	const char *name;
>> 	void *buffer;
>> 	size_t size;
>> 	int flags;
> Does 'get' need flags?
>
:-) That was the _whole_ point of the patch, flags is how we pass in the 
recursion so that a security/internal getxattr call has the rights to 
acquire the data in the lower layer(s).

-- Mark
