From: Mike Marshall <hubcap@omnibond.com>
Subject: Re: [PATCH v8] Add flags option to get xattr method paired to
 __vfs_getxattr
Date: Thu, 29 Aug 2019 21:24:38 -0400
Message-ID: <CAOg9mSTCC4Z3RpEyppC50B+pnSBbV0sr-F7hbsM-B+z3c-AZVA@mail.gmail.com>
References: <20190827150544.151031-1-salyzyn@android.com>
 <20190828142423.GA1955@infradead.org>
 <5dd09a38-fffb-36f2-505b-be2ddf6bb750@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <5dd09a38-fffb-36f2-505b-be2ddf6bb750@android.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: Mark Salyzyn <salyzyn@android.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>, Hugh Dickins <hughd@google.com>, James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>, devel@lists.orangefs.org, Eric Van Hensbergen <ericvh@gmail.com>, Joel Becker <jlbec@evilplan.org>, Anna Schumaker <anna.schumaker@netapp.com>, Trond Myklebust <trond.myklebust@hammerspace.com>, Mathieu Malaterre <malat@debian.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.com>, Casey Schaufler <casey@schaufler-ca.com>, Andrew Morton <akpm@linux-foundation.org>, Dave Kleikamp <shaggy@kernel.org>, linux-doc@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, Chao Yu <yuchao0@huawei.com>, Mimi Zohar <zohar@linux.ibm.com>, linux-cifs@vger.kernel.org, Paul Moore <paul@paul-moore.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@sandeen.net>kernel
List-Id: linux-unionfs@vger.kernel.org

SSBhZGRlZCB0aGlzIHBhdGNoIHNlcmllcyBvbiB0b3Agb2YgTGludXggNS4zLXJjNiBhbmQgcmFu
IHhmc3Rlc3RzCm9uIG9yYW5nZWZzIHdpdGggbm8gcmVncmVzc2lvbnMuCgpBY2tlZC1ieTogTWlr
ZSBNYXJzaGFsbCA8aHViY2FwQG9tbmlib25kLmNvbT4KCi1NaWtlCgpPbiBXZWQsIEF1ZyAyOCwg
MjAxOSBhdCAxMDo0MCBBTSBNYXJrIFNhbHl6eW4gPHNhbHl6eW5AYW5kcm9pZC5jb20+IHdyb3Rl
Ogo+Cj4gT24gOC8yOC8xOSA3OjI0IEFNLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPiA+IE9u
IFR1ZSwgQXVnIDI3LCAyMDE5IGF0IDA4OjA1OjE1QU0gLTA3MDAsIE1hcmsgU2FseXp5biB3cm90
ZToKPiA+PiBSZXBsYWNlIGFyZ3VtZW50cyBmb3IgZ2V0IGFuZCBzZXQgeGF0dHIgbWV0aG9kcywg
YW5kIF9fdmZzX2dldHhhdHRyCj4gPj4gYW5kIF9fdmZzX3NldGF4dHIgZnVuY3Rpb25zIHdpdGgg
YSByZWZlcmVuY2UgdG8gdGhlIGZvbGxvd2luZyBub3cKPiA+PiBjb21tb24gYXJndW1lbnQgc3Ry
dWN0dXJlOgo+ID4gWWlrZXMuICBUaGF0IGxvb2tzIGxpa2UgYSBtZXNzLiAgV2h5IGNhbid0IHdl
IHBhc3MgYSBrZXJuZWwtb25seQo+ID4gZmxhZyBpbiB0aGUgZXhpc3RpbmcgZmxhZ3MgZmllbGQg
Zm9yIOKCiz5zZXQgYW5kIGFkZCBhIGZsYWdzIGZpZWxkCj4gPiB0byAtPmdldD8gIFBhc3Npbmcg
bWV0aG9kcyBieSBzdHJ1Y3R1cmUgYWx3YXlzIHRlbmRzIHRvIGJlIGEgbWVzcy4KPgo+IFRoaXMg
d2FzIGEgcmVzcG9uc2UgdG8gR3JlZ0tIQCBjcml0aWNpc20sIGFuIGVhcmxpZXIgcGF0Y2ggc2V0
IGp1c3QKPiBhZGRlZCBhIGZsYWcgYXMgeW91IHN0YXRlZCB0byBnZXQgbWV0aG9kLCB1bnRpbCBj
b21wbGFpbnRzIG9mIGFuCj4gZXhjZXNzaXZlbHkgbG9uZyBhcmd1bWVudCBsaXN0IGFuZCBmcmFn
aWxpdHkgdG8gYWRkIG9yIGNoYW5nZSBtb3JlCj4gYXJndW1lbnRzLgo+Cj4gU28gbWFueSB3YXlz
IGhhdmUgYmVlbiB0cmllZCB0byBza2luIHRoaXMgY2F0IC4uLiB0aGUgcmlzayB3YXMgdGFrZW4g
dG8KPiBwbGVhc2Ugc29tZSwgYW5kIHdlIG5vdyBoYXZlIGh1bmRyZWRzIG9mIHN0YWtlaG9sZGVy
cywgd2hlbiB0aGUgZmlyc3QKPiBwYXRjaCBzZXQgd2FzIGxlc3MgdGhhbiBhIGRvemVuLiBBIHJl
Y2lwZSBmb3IgZmFpbHVyZT8KPgo+IC0tIE1hcmsKPgoKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4IE1URCBkaXNjdXNzaW9uIG1haWxp
bmcgbGlzdApodHRwOi8vbGlzdHMuaW5mcmFkZWFkLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4
LW10ZC8K
